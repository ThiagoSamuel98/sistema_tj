class Documento < ApplicationRecord
  validates :titulo, presence: true
end
