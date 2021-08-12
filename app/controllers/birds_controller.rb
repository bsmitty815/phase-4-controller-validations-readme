class BirdsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_response
  # added rescue_from
  rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity_response

  # GET /birds
  def index
    birds = Bird.all
    render json: birds
  end

  # POST /birds
  def create
    bird = Bird.create(bird_params)
    render json: bird, status: :created
    # we do not need it here because we have it up top in our code
  # rescue ActiveRecord::RecordInvalid => invalid
  #   render json: { errors: invalid.record.errors }, status: :unprocessable_entity
  end

  # GET /birds/:id
  def show
    bird = find_bird
    render json: bird
  end

  # PATCH /birds/:id
  def update
    bird = find_bird
    bird.update(bird_params)
    render json: bird
    # we do not need it here because we have it up top in our code
  # rescue ActiveRecord::RecordInvalid => invalid
  #   render json: { errors: invalid.record.errors }, status: :unprocessable_entity
  end

  # DELETE /birds/:id
  def destroy
    bird = find_bird
    bird.destroy
    head :no_content
  end

  private

  def render_unprocessable_entity_response(invalid)
    render json: { errors: invalid.record.errors }, status: :unprocessable_entity
    # this json response will send back this
    #     {
    #       "errors": {
    #       "name": ["can't be blank"],
    #       "species": ["must be unique"]
    #       }
    #     } 

    # we could also use full_messages to send back a slightly different message in json
    # render json: { errors: invalid.record.errors.full_messages }, status: :unprocessable_entity 
    # {
    #  "errors": ["Name can't be blank", "Species must be unique"]
    # } 
  end

  def find_bird
    Bird.find(params[:id])
  end

  def bird_params
    params.permit(:name, :species, :likes)
  end

  def render_not_found_response
    render json: { error: "Bird not found" }, status: :not_found
  end

end
