class ProjectSerializer < ActiveModel::Serializer
  attributes(
    :id,
    :name,
    :harvest_id,
    :unit_price
  )
end
