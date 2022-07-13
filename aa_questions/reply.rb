require_relative 'questionDB.rb'
require 'byebug'

class Reply
    attr_accessor :id, :question_id, :parent_id, :user_id, :body

    def initialize(options)
        @id = options['id']
        @question_id = options['question_id']
        @parent_id = options['parent_id']
        @user_id = options['user_id']
        @body = options['body']
    end

    def self.find_by_user_id(user_id)
        data = QuestionsDatabase.instance.execute(<<-SQL, user_id)
            SELECT
            *
            FROM 
            replies
            WHERE
            replies.user_id = ?
        SQL

        data.map { |datum| Reply.new(datum) }
    end

    def self.find_by_question_id(question_id)
        data = QuestionsDatabase.instance.execute(<<-SQL, question_id)
            SELECT
            *
            FROM
            replies
            WHERE
            replies.question_id = ?
        SQL

        data.map { |datum| Reply.new(datum) }
    end

end