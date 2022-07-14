require_relative "questionDB.rb"
require_relative "question.rb"
require_relative "question_follow.rb"
require_relative "question_like.rb"
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

    def followed_questions
        QuestionFollow.followed_questions_for_user_id(self.id)
    end

    def liked_questions
        QuestionLike.liked_questions_for_user_id(self.id)
    end

    def average_karma
        data = QuestionsDatabase.instance.execute(<<-SQL, self.id)
            SELECT 
        SQL
    end
end