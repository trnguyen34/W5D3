require_relative "questionDB.rb"
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
        p data
        Question.new(data.first)
    end

    attr_accessor :title, :body, :user_id

    def initialize(options)
        @id = options["id"]
        @title = options["title"]
        @body = options["body"]
        @user_id = options["user_id"]
    end
end