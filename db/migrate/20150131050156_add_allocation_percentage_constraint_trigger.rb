class AddAllocationPercentageConstraintTrigger < ActiveRecord::Migration
  def change
    reversible do |dir|
      dir.up do
        # maybe need to run check for both old and new?
        execute <<-SQL
          CREATE OR REPLACE FUNCTION sum_allocation_percentages(selected_portfolio_id integer)
            RETURNS numeric AS $$
            BEGIN
              RETURN (
                SELECT sum(weight)
                  FROM allocations
                  WHERE allocations.portfolio_id = selected_portfolio_id
              );
            END;
          $$ LANGUAGE plpgsql;

          CREATE OR REPLACE FUNCTION check_allocation_percentages() RETURNS trigger AS $$
            BEGIN
              -- sum_allocation_percentages returns NULL if there are no
              -- remaining allocations for this portfolio_id, which just lets
              -- the operation continue (that's not an error).
              IF (TG_OP = 'INSERT' OR TG_OP = 'UPDATE') THEN
                IF sum_allocation_percentages(NEW.portfolio_id) != 1.0 THEN
                  RAISE EXCEPTION 'Portfolio % allocation weights must equal 1.0', NEW.portfolio_id;
                END IF;
              END IF;

              IF (TG_OP = 'UPDATE' OR TG_OP = 'DELETE') THEN
                IF sum_allocation_percentages(OLD.portfolio_id) != 1.0 THEN
                  RAISE EXCEPTION 'Portfolio % allocation weights must equal 1.0', OLD.portfolio_id;
                END IF;
              END IF;

              RETURN NULL;
            END;
          $$ LANGUAGE plpgsql;

          CREATE CONSTRAINT TRIGGER allocation_percentage_trigger
            AFTER INSERT OR UPDATE OR DELETE ON allocations
            DEFERRABLE INITIALLY DEFERRED
            FOR EACH ROW
            EXECUTE PROCEDURE check_allocation_percentages();
        SQL
      end
      dir.down do
        execute <<-SQL
          DROP TRIGGER IF EXISTS allocation_percentage_trigger ON allocations;
          DROP FUNCTION IF EXISTS check_allocation_percentages();
          DROP FUNCTION IF EXISTS sum_allocation_percentages(integer);
        SQL
      end
    end
  end
end
