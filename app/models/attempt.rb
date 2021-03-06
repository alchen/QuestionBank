class Attempt < ActiveRecord::Base
  belongs_to :question
  belongs_to :user

  attr_accessible :answer, :is_correct, :created_at, :question_id, :user_id, :updated_at
  
  def self.retrieve_by_user_group(user_group_id) 
  	Attempt.includes(:user => [:user_groups]).where("user_groups.id = ?", user_group_id)
  end

  def self.retrieve_by_question_group(question_group_id) 
  	Attempt.includes(:question => [:question_groups]).where("question_groups.id = ?", question_group_id)
  end

  def self.retrieve_by_user_group_and_question_group(user_group_id, question_group_id)
	Attempt.includes(:user => [:user_groups], :question => [:question_groups]).where("user_groups.id = ? and question_groups.id = ?", user_group_id, question_group_id)
  end
end
