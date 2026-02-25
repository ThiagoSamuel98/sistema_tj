class Documento < ApplicationRecord
  # Isso garante que ninguém salve um documento sem título no sistema
  validates :titulo, presence: true
end