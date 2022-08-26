class DocumentSerializer < ActiveModel::Serializer
  attributes(
    :id,
    :bsale_id,
    :url
  )
end
