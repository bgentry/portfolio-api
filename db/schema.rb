Sequel.migration do
  change do
    create_table(:asset_classes) do
      primary_key :id
      column :name, "text", :null=>false
      column :created_at, "timestamp without time zone", :null=>false
      column :updated_at, "timestamp without time zone", :null=>false
    end
    
    create_table(:portfolios) do
      primary_key :id
      column :name, "text", :null=>false
      column :created_at, "timestamp without time zone", :null=>false
      column :updated_at, "timestamp without time zone", :null=>false
      column :taxable, "boolean", :default=>true, :null=>false
    end
    
    create_table(:schema_migrations) do
      column :filename, "text", :null=>false
      
      primary_key [:filename]
    end
    
    create_table(:allocations) do
      primary_key :id
      foreign_key :asset_class_id, :asset_classes, :key=>[:id], :on_delete=>:restrict
      foreign_key :portfolio_id, :portfolios, :key=>[:id], :on_delete=>:restrict
      column :weight, "numeric(3,2)", :null=>false
      column :created_at, "timestamp without time zone", :null=>false
      column :updated_at, "timestamp without time zone", :null=>false
      
      index [:portfolio_id, :asset_class_id], :unique=>true
    end
    
    create_table(:funds) do
      primary_key :id
      foreign_key :asset_class_id, :asset_classes, :key=>[:id], :on_delete=>:restrict
      column :name, "text", :null=>false
      column :symbol, "text", :null=>false
      column :expense_ratio, "numeric(4,4)", :null=>false
      column :price, "money", :null=>false
      column :created_at, "timestamp without time zone", :null=>false
      column :updated_at, "timestamp without time zone", :null=>false
      column :price_updated_at, "timestamp without time zone"
      
      index [:symbol], :unique=>true
    end
    
    create_table(:lots) do
      primary_key :id
      foreign_key :fund_id, :funds, :key=>[:id], :on_delete=>:restrict
      foreign_key :portfolio_id, :portfolios, :key=>[:id], :on_delete=>:restrict
      column :acquired_at, "timestamp without time zone", :null=>false
      column :sold_at, "timestamp without time zone"
      column :quantity, "numeric(15,6)", :null=>false
      column :share_cost, "money", :null=>false
      column :proceeds, "money"
      column :created_at, "timestamp without time zone", :null=>false
      column :updated_at, "timestamp without time zone", :null=>false
    end
  end
end
Sequel.migration do
  change do
    self << "INSERT INTO \"schema_migrations\" (\"filename\") VALUES ('20150128011359_create_asset_classes.rb')"
    self << "INSERT INTO \"schema_migrations\" (\"filename\") VALUES ('20150128012854_create_funds.rb')"
    self << "INSERT INTO \"schema_migrations\" (\"filename\") VALUES ('20150128022329_create_portfolios.rb')"
    self << "INSERT INTO \"schema_migrations\" (\"filename\") VALUES ('20150128023952_create_allocations.rb')"
    self << "INSERT INTO \"schema_migrations\" (\"filename\") VALUES ('20150128025243_create_lots.rb')"
    self << "INSERT INTO \"schema_migrations\" (\"filename\") VALUES ('20150131050156_add_allocation_percentage_constraint_trigger.rb')"
    self << "INSERT INTO \"schema_migrations\" (\"filename\") VALUES ('20150203060428_add_unique_index_to_allocations.rb')"
    self << "INSERT INTO \"schema_migrations\" (\"filename\") VALUES ('20150205074838_add_price_updated_at_to_funds.rb')"
    self << "INSERT INTO \"schema_migrations\" (\"filename\") VALUES ('20150206061849_add_unique_index_to_fund_symbol.rb')"
    self << "INSERT INTO \"schema_migrations\" (\"filename\") VALUES ('20150207214513_add_taxable_to_portfolio.rb')"
  end
end
