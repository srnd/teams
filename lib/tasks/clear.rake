namespace :clear do
  desc "Makes sure that regions and batches are up-to-date with Clear's records."
  task sync: :environment do
    # update the batches first, since regions rely on them
    batches = $clear.get_batches

    batches.each do |batch|
      batch = batch.deep_symbolize_keys
      if Batch.where(:clear_id => batch[:id]).exists?
        puts "Updating batch #{batch[:id]}"
        Batch.where(:clear_id => batch[:id]).first.update(:name => batch[:name], :current => batch[:is_loaded])
      else
        puts "Creating new batch #{batch[:id]}"
        Batch.create(:name => batch[:name], :clear_id => batch[:id], :current => batch[:is_loaded])
      end
    end

    # update the regions and add them to current batch
    
    # NOTE: the `Event` model represents a region, I'm using it for backwards
    # compatability with old views/controllers, we will eventually update it
    # when it's time
    regions = $clear.get_regions

    regions.each do |region|
      region = region.deep_symbolize_keys
      if Event.where(:clear_id => region[:id]).exists?
        puts "Updating region #{region[:id]}"
        Event.where(:clear_id => region[:id]).first.update({
          :city => region[:name],
          :webname => region[:webname]
        })
      else
        puts "Creating new region #{region[:id]}"
        Event.create({
          :clear_id => region[:id],
          :city => region[:name],
          :webname => region[:webname]
        })
      end
    end
  end

  desc "Checks the permissions of volunteer users to make sure that they still have access to the event."
  task check_permissions: :environment do

  end
end
