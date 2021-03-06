class Question < ActiveRecord::Base
  attr_accessible :xml, :tag_ids
  has_and_belongs_to_many :tags
  has_and_belongs_to_many :question_groups
  has_many :question_values
  belongs_to :user
  has_many :attempts

  def self.get_quiz(number_of_questions, tag_name)
    # Wonder if there is a cleaner way to do this
    all_tagged_questions = Question.all(:include => :tags, :conditions => ["tags.id = ?", tag_name])
    return all_tagged_questions.take([all_tagged_questions.length, Integer(number_of_questions)].min)
  end
end
