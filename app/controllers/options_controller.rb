class OptionsController < ApplicationController
  before_action :check_admin, except: [:show]

  def show
    redirect_to root_path
  end

  def edit
    @options = Option.find(1)
  end

  # PUT /options/1
  # PUT /options/1.json
  def update
    @options = Option.find(params[:id])
    respond_to do |format|
      if @options.update_attributes(options_params)
        format.html { redirect_to root_path, notice: 'Options were successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @options.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  # Only allow a list of trusted parameters through.
  def options_params
    params.require(:option).permit(:tag_ids => [], :category_ids => [])
  end
end
