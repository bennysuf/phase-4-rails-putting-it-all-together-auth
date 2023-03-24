class RecipesController < ApplicationController
    rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity_response
    rescue_from ActionController::UnpermittedParameters, with: :render_unpermitted_params_response

    def index
        user = User.find_by(id: session[:user_id])
        if user 
            recipe = user.recipes
            render json: recipe, status: :created
        else
            render json: {errors: [login: "Not logged in"]}, status: :unauthorized
        end
    end

    def create
        user = User.find_by(id: session[:user_id])
        if user 
            # byebug
            # recipe = Recipe.create!(recipe_params)
            recipe = Recipe.create!(
                title: params[:title], 
                instructions: params[:instructions], 
                user_id: session[:user_id], 
                minutes_to_complete: params[:minutes_to_complete] )
                byebug
            render json: recipe, status: :created
        else
            render json: {errors: [login: "Not logged in"]}, status: :unauthorized
        end

    end

    private 

    # def recipe_params
    #     params.permit(:title, :instructions, :user_id, :minutes_to_complete, recipe: [])
    # end

    def render_unprocessable_entity_response(invalid)
        render json: { errors: [validation: invalid.record.errors] }, status: :unprocessable_entity
    end

    # def render_changes_to_permitted_entity_response
    #     byebug
    #     render json: { "Unpermitted Parameters": params.to_unsafe_h.except(:controller, action: "recipe")}, status: :unprocessable_entity
    # end
    # def render_unpermitted_params_response
    #     # byebug
    #     render json: { "Unpermitted Parameters": params.to_unsafe_h.except(:user_id, :title, :id, :instructions, :minutes_to_complete, :recipe).keys }, status: :unprocessable_entity
    # #     # render json: { "Unpermitted Parameters": params.to_unsafe_h.except(:controller, :action, :id, :username, :password).keys }, status: :unprocessable_entity
    # end
end
