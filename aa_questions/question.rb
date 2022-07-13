require_relative "questionDB.rb"
require_relative "user.rb"
require_relative "question_follow.rb"
require "byebug"

class Question

    def self.find_by_id(id)
        data = QuestionsDatabase.instance.execute(<<-SQL, id)
            SELECT 
            *
            FROM 
            questions
            WHERE 
            questions.id = ?
        SQL
        Question.new(data.first)
    end

    attr_accessor :id, :title, :body, :user_id

    def initialize(options)
        @id = options["id"]
        @title = options["title"]
        @body = options["body"]
        @user_id = options["user_id"]
    end

    def self.find_by_author_id(author_id)
        data = QuestionsDatabase.instance.execute(<<-SQL, author_id)
            SELECT
            *
            FROM
            questions
            WHERE
            questions.user_id = ?
        SQL
        if data.length == 1
            Question.new(data[0])
            else
            data.map { |datum| Question.new(datum) }
            end
    end

    def author
        data = QuestionsDatabase.instance.execute(<<-SQL, self.user_id)
            SELECT
            fname, lname
            FROM
            users
            WHERE
            users.id = ?
        SQL
        User.new(data.first)
    end

    def replies
        Reply.find_by_question_id(self.id)
    end

    def followers
        QuestionFollow.followers_for_question_id(self.id)
    end
end

