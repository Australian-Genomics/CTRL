class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates :first_name, :family_name, presence: true, allow_blank: false

  enum flagship: ['Acute Care Genomic Testing', 'Acute Lymphoblastic Leukaemia']
end
