require 'rails_helper'
require 'factory_girl_rails'

describe Food do
	it "is valid with a name and description" do
	    food = Food.new(
	      name: "Nasi Uduk",
	      description: "Betawi style steamed rice cooked in coconut milk. Delicious!",
	      price: 10000.0
	    )
	    expect(food).to be_valid
  	end
	
	it "is invalid without a name" do
	    food = Food.new(
	      name: nil,
	      description: "Betawi style steamed rice cooked in coconut milk. Delicious!",
	      price: 10000.0
	    )
	    food.valid?
	    expect(food.errors[:name]).to include("can't be blank")
  	end
  
	it "is invalid without a description" do
	    food = Food.new(
	      name: "Nasi Uduk",
	      description: nil,
	      price: 10000.0
	    )
	    food.valid?
	    expect(food.errors[:description]).to include("can't be blank")
  	end
  	
  	it "is invalid with a duplicate name" do
	    food1 = Food.create(
	      name: "Nasi Uduk",
	      description: "Betawi style steamed rice cooked in coconut milk. Delicious!",
	      price: 10000.0
	    )
	    
	    food2 = Food.new(
	      name: "Nasi Uduk",
	      description: "Just with a different description.",
	      price: 10000.0
	    )
	    food2.valid?
	    expect(food2.errors[:name]).to include("has already been taken")
  	end
  	
  	it "returns a sorted array of results that match" do
	    food1 = Food.create(
	      name: "Nasi Uduk",
	      description: "Betawi style steamed rice cooked in coconut milk. Delicious!",
	      price: 10000.0
	    )
	
	    food2 = Food.create(
	      name: "Kerak Telor",
	      description: "Betawi traditional spicy omelette made from glutinous rice cooked with egg and served with serundeng.",
	      price: 8000.0
	    )
	
	    food3 = Food.create(
	      name: "Nasi Semur Jengkol",
	      description: "Based on dongfruit, this menu promises a unique and delicious taste with a small hint of bitterness.",
	      price: 8000.0
	    )
	    expect(Food.by_letter("N")).to eq([food3, food1])
 	end
 	
 	it "omits results that do not match" do
	    food1 = Food.create(
	      name: "Nasi Uduk",
	      description: "Betawi style steamed rice cooked in coconut milk. Delicious!",
	      price: 10000.0
	    )
	
	    food2 = Food.create(
	      name: "Kerak Telor",
	      description: "Betawi traditional spicy omelette made from glutinous rice cooked with egg and served with serundeng.",
	      price: 8000.0
	    )
	
	    food3 = Food.create(
	      name: "Nasi Semur Jengkol",
	      description: "Based on dongfruit, this menu promises a unique and delicious taste with a small hint of bitterness.",
	      price: 8000.0
	    )
	
	    expect(Food.by_letter("N")).not_to include(food2)
  	end
  	
  	describe "filter name by letter" do
	    before :each do
	          @food1 = Food.create(
	            name: "Nasi Uduk",
	            description: "Betawi style steamed rice cooked in coconut milk. Delicious!",
	            price: 10000.0
	          )
	    
	          @food2 = Food.create(
	            name: "Kerak Telor",
	            description: "Betawi traditional spicy omelette made from glutinous rice cooked with egg and served with serundeng.",
	            price: 8000.0
	          )
	    
	          @food3 = Food.create(
	            name: "Nasi Semur Jengkol",
	            description: "Based on dongfruit, this menu promises a unique and delicious taste with a small hint of bitterness.",
	            price: 8000.0
	          )
    	    end
    	    
    	    describe "filter name by letter" do
	        context "with matching letters" do
	          it "returns a sorted array of results that match" do
	            expect(Food.by_letter("N")).to eq([@food3, @food1])
	          end
	        end
	    
	        context "with non-matching letters" do
	          it "omits results that do not match" do
	            expect(Food.by_letter("N")).not_to include(@food2)
	          end
	        end
  	    end   
  	end
  	
  	it "has a valid factory" do
	    expect(build(:food)).to be_valid
  	end
  
  	it "is valid with a name and description" do
	    expect(build(:food)).to be_valid
	end
	
	it "is invalid without a name" do
	    food = build(:food, name: nil)
	    food.valid?
	    expect(food.errors[:name]).to include("can't be blank")
	end
	
	it "is invalid without a description" do
	    food = build(:food, description: nil)
	    food.valid?
	    expect(food.errors[:description]).to include("can't be blank")
 	end
 	
 	it "is invalid with a duplicate name" do
	    food1 = create(:food, name: "Nasi Uduk")
	    food2 = build(:food, name: "Nasi Uduk")
	
	    food2.valid?
	    expect(food2.errors[:name]).to include("has already been taken")
  	end
  	
  	it "is valid with numeric price greater or equal to 0.01" do
	    expect(build(:food, price: 0.01)).to be_valid
	  end
	
	it "is invalid without numeric price" do
	    food = build(:food, price: "abc")
	    food.valid?
	    expect(food.errors[:price]).to include("is not a number")
	end
	
	it "is invalid with price less than 0.01" do
	    food = build(:food, price: -10)
	    food.valid?
	    expect(food.errors[:price]).to include("must be greater than or equal to 0.01")
  	end
 	
end

# kalau di rspec 3.xx, kita harus spesifikasiin kalau yang kita describe itu controller dengan tambahin :type => :controller
describe FoodsController, :type => :controller do
  describe 'GET #index' do
      context 'with params[:letter]' do
        it "populates an array of foods starting with the letter" do
          nasi_uduk = create(:food, name: "Nasi Uduk")
	  kerak_telor = create(:food, name: "Kelar Telor")
	  get :index, params: { letter: 'N' }
          expect(assigns(:foods)).to match_array([nasi_uduk])
        end
        
        it "renders the :index template" do
          get :index, params: { letter: 'N' }
          expect(response).to render_template :index
        end
      end
  
      context 'without params[:letter]' do
        it "populates an array of all foods" do
          nasi_uduk = create(:food, name: "Nasi Uduk")
	  kerak_telor = create(:food, name: "Kelar Telor")
	  get :index
          expect(assigns(:foods)).to match_array([nasi_uduk, kerak_telor])
        end
        
        it "renders the :index template" do
          get :index
          expect(response).to render_template :index
        end
      end
  end
  
  describe 'GET #show' do
      it "assigns the requested food to @food" do
      	food = create(:food)
	get :show, params: { id: food }
      	expect(assigns(:food)).to eq food
      end
      
      it "renders the :show template" do
      	food = create(:food)
	get :show, params: { id: food }
        expect(response).to render_template :show
      end
  end
  
  describe 'GET #new' do
      it "assigns a new Food to @food"
      it "renders the :new template"
  end
  
  describe 'GET #edit' do
      it "assigns the requested food to @food"
      it "renders the :edit template"
  end
  
  describe 'POST #create' do
      context "with valid attributes" do
        it "saves the new food in the database"
        it "redirects to foods#show"
      end
  
      context "with invalid attributes" do
        it "does not save the new food in the database"
        it "re-renders the :new template"
      end
  end
  
  describe 'PATCH #update' do
      context "with valid attributes" do
        it "locates the requested @food"
        it "changes @food's attributes"
        it "redirects to the food"
      end
  
      context "with invalid attributes" do
        it "does not update the food in the database"
        it "re-renders the :edit template"
      end
  end
  
  describe 'DELETE #destroy' do
      it "deletes the food from the database"
      it "redirects to foods#index"
  end
  
end