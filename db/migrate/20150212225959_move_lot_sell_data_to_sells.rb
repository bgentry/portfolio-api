Sequel.migration do
  up do
    lots_to_split = from(:lots).where(sold_at: nil).invert.
      select(:sold_at, :quantity, :created_at, :updated_at).
      select_append{id.as(lot_id)}.
      select_append{(proceeds / Sequel.cast(:share_cost, :decimal)).as(price)}
    from(:sells).insert([:sold_at, :quantity, :created_at, :updated_at, :lot_id, :price], lots_to_split)
  end

  down do
    raise Sequel::Error.new("not reversible")
  end
end
