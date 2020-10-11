class GroupsController < ApplicationController
  before_action :set_group, only: [:show, :edit, :update, :destroy]

  # Redirect if user isn't an admin and attempts to access admin only pages.
  before_action :check_admin, except: [:show, :index]

  def show
    @tags = @group.tags.order(:name)
    @categories = @group.categories.order(:name)
  end

  def index
    @groups = Group.all
  end

  def new
    @group = Group.new
  end

  def edit

  end

  # POST /groups
  # POST /groups.json
  def create
    par = group_params
    par[:tag_ids].reject!(&:blank?)
    par[:category_ids].reject!(&:blank?)
    @group = Group.new(par)

    respond_to do |format|
      if @group.save
        format.html { redirect_to @group, notice: 'Group was successfully created.' }
        format.json { render json: @group, status: :created, location: @group }
      else
        format.html { render action: "new" }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /groups/1
  # PUT /groups/1.json
  def update
    respond_to do |format|
      if @group.update_attributes(group_params)
        format.html { redirect_to @group, notice: 'Group was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /groups/1
  # DELETE /groups/1.json
  def destroy
    @group.destroy
    respond_to do |format|
      format.html { redirect_to recipes_url, notice: 'Group was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  
  private

  def set_group
    @group = Group.friendly.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def group_params
    params.require(:group).permit(:name, :tag_ids => [], :category_ids => [])
  end
end