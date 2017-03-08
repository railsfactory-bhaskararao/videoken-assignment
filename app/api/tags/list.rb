module Tags
  class List < Grape::API

  	include Exceptions::Handler

  	helpers do
		 	def safe_params
    		declared(params, { include_missing: false })
  		end
  	end

    resource :tags do
      desc "If the entity exists, it should replace tags but not append"
      params do
        requires :tags, type: Hash do
          requires :entity_type, type: String
          requires :entity_id, type: Integer
          requires :tags_list, type: Array do
          	requires :name, type: String
          end
        end
      end
      post do
        clean_params = safe_params[:tags]
      	entity = clean_params[:entity_type].capitalize.constantize
      	entity = entity.find(clean_params[:entity_id])
      	entity.tags.destroy_all
      	entity.tags.create(safe_params[:tags][:tags_list])
      	{entity: entity, tags: entity.tag_list}
      end

      desc "Retrieve an entity"
      params do
        requires :entity_type, type: String
        requires :entity_id, type: Integer
      end

      get '/entity/:entity_type/:entity_id' do
        clean_params = safe_params(params)
      	entity = clean_params[:entity_type].capitalize.constantize
      	entity = entity.find(clean_params[:entity_id])
      	{ message: 'Entity has been successfully retrieved.', entity: entity}
      end

      desc "Remove an entity and it's tags"
      params do
        requires :entity_type, type: String
        requires :entity_id, type: Integer
      end
      delete '/entity/:entity_type/:entity_id' do
        clean_params = safe_params(params)
      	entity = clean_params[:entity_type].capitalize.constantize
      	entity = entity.find(clean_params[:entity_id])
      	entity.tags.destroy_all
      	entity.destory
      	{ message: 'Entity has been successfully destoryed', status: 200 }
      end

      desc "Retrieve stats about all tags"
      get '' do
	      { message: 'Tags info successfully retrieved.', 
	      	tags_stats: ActsAsTaggableOn::Tag.all
				}        
      end

      desc "Retrieve stats about given entity"
      
      params do
    		requires :entity_type, type: String
    		requires :entity_id, type: Integer
      end

      get '/:entity_type:/entity_id'do
        clean_params = safe_params(params)
        entity = clean_params[:entity_type].capitalize.constantize
      	entity = entity.find(clean_params[:entity_id])
      	{message: 'Tags have been successfully retrieved.', tags: entity.tag_list}
      end
    end
  end
end