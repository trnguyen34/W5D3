require_relative 'questionDB.rb'
require_relative 'user.rb'
require_relative 'question.rb'
require 'byebug'

class QuestionFollow 

    def initialize(options)
        @id = options['id']
        @question_id = options['question_id']
        @user_id = options['user_id']
    end

    def self.followers_for_question_id(question_id)
        data = QuestionsDatabase.instance.execute(<<-SQL, question_id)
            SELECT 
            *
            FROM 
            users 
            JOIN 
            question_follows
            ON 
            users.id = question_follows.user_id
            WHERE
            question_follows.question_id = ?
        SQL

        if data.length == 1
            User.new(data.first)
        else
            data.map { |datum| User.new(datum) }
        end
    end

    def self.followed_questions_for_user_id(user_id)
        data = QuestionsDatabase.instance.execute(<<-SQL, user_id)
            SELECT
            *
            FROM 
            questions
            JOIN
            question_follows
            ON
            questions.id = question_follows.question_id
            WHERE
            question_follows.user_id = ?
        SQL

        if data.length == 1
            Question.new(data.first)
        else
            data.map{ |datum| Question.new(datum) }
        end
    end
end