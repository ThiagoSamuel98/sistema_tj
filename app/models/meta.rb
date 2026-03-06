class Meta < ApplicationRecord
  self.table_name = "metas"

  belongs_to :indicador

  validates :ano, presence: true
  validates :tipo_objetivo, numericality: { greater_than_or_equal_to: 0, allow_nil: true }
  validates :formato_objetivo, inclusion: { in: %w[percentual decimal], allow_nil: true }
end
