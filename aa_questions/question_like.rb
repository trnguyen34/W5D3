require_relative "questionDB.rb"
require_relative "user.rb"
require_relative "question.rb"
require "byebug"

class QuestionLike

    def self.likers_for_question_id(question_id)
        data = QuestionsDatabase.instance.execute(<<-SQL, question_id)
            SELECT 
            *
            FROM 
            users 
            JOIN 
            question_likes
            ON 
            users.id = question_likes.user_id
            WHERE
            question_likes.question_id = ?
        SQL
        
        if data.length == 1
            User.new(data.first)
        else
            data.map { |datum| User.new(datum) }
        end
    end

    def self.liked_questions_for_user_id(user_id)
        data = QuestionsDatabase.instance.execute(<<-SQL, user_id)
            SELECT 
            questions.*
            FROM 
            questions 
            JOIN 
            question_likes
            ON 
            questions.id = question_likes.question_id
            WHERE
            question_likes.user_id = ?
        SQL
        if data.length == 1
            Question.new(data.first)
        else
            data.map { |datum| Question.new(datum) }
        end
    end 

    def self.num_likes_for_question_id(question_id) 
        data = QuestionsDatabase.instance.execute(<<-SQL, question_id)
            SELECT
            count(*) as num_likes
            FROM 
            questions
            JOIN
            question_follows
            ON
            questions.id = question_follows.question_id
            WHERE
            questions.id = ?
            GROUP BY question_id
            
        SQL
        
        data.first["num_likes"]
        
    end

    def initialize(options)
        @id = options["id"]
        @question_id = options["question_id"]
        @user_id = options["user_id"]
    end

    def self.most_liked_questions(n)
        data = QuestionsDatabase.instance.execute(<<-SQL, n)
            SELECT
            *
            FROM 
            questions
            JOIN
            question_likes
            ON
            questions.id = question_likes.question_id
            GROUP BY question_id
            ORDER BY count(*) desc 
            LIMIT ?
        SQL
        if data.length == 1
            Question.new(data.first)
        else
            data.map{ |datum| Question.new(datum) }
        end
    end

end