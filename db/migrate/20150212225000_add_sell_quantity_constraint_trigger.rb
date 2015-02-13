Sequel.migration do
  up do
    run <<-SQL
CREATE OR REPLACE FUNCTION sum_sell_quantities(selected_lot_id integer)
  RETURNS numeric AS $$
  BEGIN
    RETURN (
      SELECT sum(quantity)
        FROM sells
        WHERE sells.lot_id = selected_lot_id
    );
  END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION check_sell_quantities() RETURNS trigger AS $$
  DECLARE
    lot_quantity numeric;
  BEGIN
    SELECT quantity INTO lot_quantity FROM lots WHERE id = NEW.lot_id;
    IF sum_sell_quantities(NEW.lot_id) > lot_quantity THEN
      RAISE EXCEPTION 'Lot % sell quantities cannot exceed lot quantity %', NEW.lot_id, lot_quantity;
    END IF;

    RETURN NULL;
  END;
$$ LANGUAGE plpgsql;

CREATE CONSTRAINT TRIGGER cell_quantity_trigger
  AFTER INSERT OR UPDATE ON sells
  FOR EACH ROW
  EXECUTE PROCEDURE check_sell_quantities();
    SQL
  end

  down do
    run <<-SQL
DROP TRIGGER IF EXISTS cell_quantity_trigger ON sells;
DROP FUNCTION IF EXISTS check_sell_quantities();
DROP FUNCTION IF EXISTS sum_sell_quantities(integer);
    SQL
  end
end
