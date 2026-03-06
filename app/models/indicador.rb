class Indicador < ApplicationRecord
  self.table_name = "indicadores"

  has_many :serie_historica, dependent: :destroy
  has_many :metas, dependent: :destroy

  validates :indicador, presence: true, uniqueness: true
  validates :tipo, presence: true, inclusion: { in: %w[nacional institucional] }
end
