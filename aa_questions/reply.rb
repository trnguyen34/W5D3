require_relative 'questionDB.rb'
require_relative 'user.rb'
require_relative 'question.rb'
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
        if data.length == 1
            Reply.new(data.first)
        else
            data.map { |datum| Reply.new(datum) }
        end
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
        if data.length == 1 
            Reply.new(data.first)
        else
            data.map { |datum| Reply.new(datum) }
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

    def question
        Question.find_by_id(self.question_id)
    end

    def parent_reply
        return nil if parent_id.nil?
        data = QuestionsDatabase.instance.execute(<<-SQL, self.parent_id)
            SELECT
            *
            FROM
            replies
            WHERE
            replies.id = ?
        SQL
        Reply.new(data.first)
    end

    def child_replies
        data = QuestionsDatabase.instance.execute(<<-SQL, self.id)
            SELECT
            *
            FROM
            replies
            WHERE
            replies.parent_id = ?
        SQL
        if data.length == 1 
            Reply.new(data.first)
        else
            data.map { |datum| Reply.new(datum) }
        end
    end


end