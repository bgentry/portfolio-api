Sequel.migration do
  change do
    alter_table :portfolios do
      add_column :taxable, TrueClass, null: false, default: true
    end
  end
end
