require_relative "questionDB.rb"
require_relative "question.rb"
require_relative "reply.rb"
# require "byebug"

class User

    attr_accessor :id, :fname, :lname

    def initialize(options)
        @id = options['id']
        @fname = options['fname']
        @lname = options['lname']
    end

    def self.find_by_name(fname, lname)
        data = QuestionsDatabase.instance.execute(<<-SQL, fname, lname)
            SELECT 
            * 
            FROM 
            users
            WHERE
            users.fname = ? AND users.lname = ?
        SQL
        User.new(data.first)
    end

    def authored_questions
        Question.find_by_author_id(self.id)
    end

    def authored_replies
        Reply.find_by_user_id(self.id)
    end
end