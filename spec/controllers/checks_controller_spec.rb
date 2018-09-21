require 'rails_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

RSpec.describe ChecksController, type: :controller do
  let(:user) { FactoryBot.create(:user) }
  let(:user2) { FactoryBot.create(:user, email: 'u2@noty.im') }

  # This should return the minimal set of attributes required to create a valid
  # Check. As you add validations to Check, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) { FactoryBot.attributes_for(:check).merge(user: user, team: user.default_team) }

  let(:invalid_attributes) {
    { uri: 'foo' }
  }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # ChecksController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  before do
    Trinity::Current.reset!
    sign_in user
  end

  describe "GET #index" do
    it "assigns all checks as @checks" do
      check = Check.create! valid_attributes
      get :index, params: {}, session: valid_session
      expect(assigns(:checks)).to eq([check])
    end
  end

  describe "GET #show" do
    it "assigns the requested check as @check" do
      check = Check.create! valid_attributes
      get :show, params: {id: check.id}, session: valid_session
      expect(assigns(:check)).to eq(check)
    end

    it "responses with forbid for no-manage ccheck" do
      check = Check.create!(valid_attributes.merge(user: user2))
      get :show, params: {id: check.to_param}, session: valid_session
      assert_response :forbidden
      expect(assigns(:check)).to eq(nil)
    end
  end

  describe "GET #new" do
    it "assigns a new check as @check" do
      get :new, params: {}, session: valid_session
      expect(assigns(:check)).to be_a_new(Check)
    end
  end

  describe "GET #edit" do
    it "assigns the requested check as @check" do
      check = Check.create! valid_attributes
      get :edit, params: {id: check.to_param}, session: valid_session
      expect(assigns(:check)).to eq(check)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Check" do
        expect {
          post :create, params: {check: valid_attributes}, session: valid_session
        }.to change(Check, :count).by(1)
      end

      it "assigns a newly created check as @check" do
        post :create, params: {check: valid_attributes}, session: valid_session
        check = Check.desc(:id).first
        expect(assigns(:check)).to be_a(Check)
        expect(assigns(:check)).to be_persisted
        expect(assigns(:check)).to eq(check)
      end

      it "redirects to the created check" do
        post :create, params: {check: valid_attributes}, session: valid_session
        expect(response).to redirect_to(Check.desc(:id).first)
      end
    end

    context "with invalid params" do
      it "assigns a newly created but unsaved check as @check" do
        post :create, params: {check: invalid_attributes}, session: valid_session
        expect(assigns(:check)).to be_a_new(Check)
        expect(assigns(:check)).to have_attributes(name: invalid_attributes[:name])
      end

      it "re-renders the 'new' template" do
        post :create, params: {check: invalid_attributes}, session: valid_session
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        { name: 'new test', uri: 'http://newtype.com' }
      }

      it "updates the requested check" do
        check = Check.create! valid_attributes
        put :update, params: {id: check.id.to_s, check: new_attributes}, session: valid_session
        check.reload
        expect(check.name).to eq(new_attributes[:name])
        expect(check.uri).to eq(new_attributes[:uri])
      end

      it "assigns the requested check as @check" do
        check = Check.create! valid_attributes
        put :update, params: {id: check.id.to_s, check: valid_attributes}, session: valid_session
        check.reload
        expect(assigns(:check)).to eq(check)
      end

      it "redirects to the check" do
        check = Check.create! valid_attributes
        put :update, params: {id: check.to_param, check: valid_attributes}, session: valid_session
        expect(response).to redirect_to(check)
      end
    end

    context "with invalid params" do
      it "assigns the check as @check" do
        check = Check.create! valid_attributes
        put :update, params: {id: check.to_param, check: invalid_attributes}, session: valid_session
        expect(assigns(:check)).to eq(check)
      end

      it "re-renders the 'edit' template" do
        check = Check.create! valid_attributes
        put :update, params: {id: check.to_param, check: invalid_attributes}, session: valid_session
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested check" do
      check = Check.create! valid_attributes
      expect {
        delete :destroy, params: {id: check.to_param}, session: valid_session
      }.to change(Check, :count).by(-1)
    end

    it "redirects to the checks list" do
      check = Check.create! valid_attributes
      delete :destroy, params: {id: check.to_param}, session: valid_session
      expect(response).to redirect_to(checks_url)
    end
  end

end
