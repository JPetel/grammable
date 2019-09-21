require 'rails_helper'

RSpec.describe GramsController, type: :controller do

  #---------------GRAM DESTROY ------------#

  describe "grams#destroy action" do
    it "should'nt allow users who didn't create the gram to destroy it" do
      gram = FactoryBot.create(:gram)
      user = FactoryBot.create(:user)
      sign_in user
      delete :destroy, params: {id: gram.id }
      expect(response).to have_http_status(:forbidden)

    end


    it "should allow a user to destroy a gram if they posted it" do
      gram = FactoryBot.create(:gram)
      sign_in gram.user
      delete :destroy, params: {id: gram.id }
      expect(response).to redirect_to root_path
      gram = Gram.find_by_id(gram.id)
      expect(gram).to eq nil
    end

    it "should return a 404 error message if we cannot find the gram the user is looking for" do
      user = FactoryBot.create(:user)
      sign_in user
      delete :destroy, params: {id: 'random message'}
      expect(response).to have_http_status(:not_found)
    end
  end


  #---------------- GRAM UPDATE -----------#
  describe "grams#update action" do
    it "should allow users to update grams" do
      gram = FactoryBot.create(:gram, message: "Initial Value")
      patch :update, params: {id: gram.id, gram: {message: 'Changed'}}
      expect(response).to redirect_to new_user_session_path
    end

    it "should have http 404 error if the gram cant be found" do
      user = FactoryBot.create(:user)
      sign_in user
      patch :update, params: { id: "nooooope", gram: {message: 'Changed'}}
      expect(response).to have_http_status(:not_found)
    end

    it "should render the edit form with an http status of unprocessable_entity" do
  gram = FactoryBot.create(:gram, message: "Initial Value")
  sign_in gram.user
  patch :update, params: { id: gram.id, gram: { message: '' } }
  expect(response).to have_http_status(:unprocessable_entity)
  gram.reload
  expect(gram.message).to eq "Initial Value"
end
  end

  #----------------GRAM EDIT ---------------#
  describe "grams#edit action" do
    it "should successfully show the edit form if gram is found" do
      gram = FactoryBot.create(:gram)
      sign_in gram.user

      get :edit, params: {id: gram.id }
      expect(response).to have_http_status(:success)
    end

    it "should return 404 not found message if the gram cant be found" do
      user = FactoryBot.create(:user)
      sign_in user

      get :edit, params: {id: 'nil' }
      expect(response).to have_http_status(:not_found)
    end
  end 


  #---------------GRAM SHOW ---------------#
  describe "grams#show action" do
    it "should successfully show the page if the gram is found" do 
      gram = FactoryBot.create(:gram)
      get :show, params: {id: gram.id }
      expect(response).to have_http_status(:success)
    end

    it "should return 404 error not found if the gram isnt found" do
      get :show, params: {id: 'nil' }
      expect(response).to have_http_status(:not_found)
    end    
  end


  #---------------GRAM INDEX ------------------#

  describe "grams#index action" do
    it "should show the page" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end


  describe "grams#new action" do
    it "should require users to be logged in" do
      get :new
      expect(response).to redirect_to new_user_session_path
    end

    it "should show the NEW form" do
      user = FactoryBot.create(:user)
      sign_in user

      get :new
      expect(response).to have_http_status(:success)
    end
  end

  #---------------- GRAM CREATE -----------#

  describe "grams#create action" do

    it "should require users to be logged in" do
      post :create, params: {grams: {message: "Hello"} }
      expect(response).to redirect_to new_user_session_path
    end


    it "should create a new gram in the database" do
      user = FactoryBot.create(:user)
      sign_in user

      post :create, params: {
        gram: {
          message: 'Hello!',
          photo: fixture_file_upload("/picture.png", 'image/png')
        }
      }
      
      expect(response).to redirect_to root_path

      gram = Gram.last
      expect(gram.message).to eq("Hello!")
      expect(gram.user).to eq(user)
    end

    it "should properly deal with valdidation errors" do
      user = FactoryBot.create(:user)
      sign_in user

      gram_count = Gram.count
      post :create, params: {gram: {message: ''}}
      expect(response).to have_http_status(:unprocessable_entity)
      expect(gram_count).to eq Gram.count
    end
  end
end

















