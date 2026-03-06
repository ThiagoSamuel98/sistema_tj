class SerieHistorica < ApplicationRecord
  self.table_name = "serie_historica"

  belongs_to :indicador

  validates :ano, presence: true
end
