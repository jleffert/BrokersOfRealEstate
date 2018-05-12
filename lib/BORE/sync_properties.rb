module BORE
  class SyncProperties
    ROOMS = ['MasterBedroom', '2ndBedroom', '3rdBedroom', '4thBedroom', 'FamilyRoom', 'FormalDiningRoom', 'GreatRoom', 
             'InformalDiningRoom', 'Kitchen', 'LaundryRoom', 'LivingRoom', 'Office', 'RecreationRoom']
    
    def self.initial_import
      rets = RubyRETS::RETS.new(ENV["RETS_USER_ID"], ENV["RETS_PASSWORD"], ENV["RETS_USER_AGENT"], 'http://rets172lax.raprets.com:6103')
      response = rets.login('/Midlands/MIDL/login.aspx')

      unless response == RubyRETS::Unauthorized
        properties = rets.search('Property', 'RESI','(City=|Lincoln),(Status=|A)', '/Midlands/MIDL/search.aspx', {standard_names: 0})
        Room.delete_all
        House.delete_all
        Lot.delete_all
        lots = []
        houses = []
        rooms = []

        properties.parsed.each do |property|
          lot = build_lot(property)
          lot.save

          house = build_house(property)
          house.lot_id = lot.id
          house.save

          ROOMS.each do |room|
            room_hash = property.select{|key, hash| key.include? room }
            if room_hash["#{room}Area"] != "0"
              room = build_room(house, room, room_hash)
              room.save
              rooms << room
            end
          end

          lots << lot
          houses << house
        end
      end

      return lots, houses, rooms
    end

    private_class_method
    def self.build_address(property)
      address = property['StreetNumber']
      address = "#{address} #{property['StreetDirection']}" if property['StreetDirPrefix'].present?
      address = "#{address} #{property['StreetName']}"
      address = "#{address} #{property['StreetPostDirection']}" if property['StreetDirSuffix'].present?
      address = "#{address} #{property['StreetSuffix']}"
      address = "#{address}  ##{property['Unit']}" if property['Unit'].present?
      address
    end

    def self.build_lot(property)
      # Gas, City, and Water source are only retured when selecting Lots for sale
      Lot.new(sub_type: property.fetch('PropertySubtype1'),
              address: build_address(property),
              zip: property['ZipCode'],
              city: property['City'],
              state: property['State'],
              directions: property['Directions'],
              list_price: property['ListingPrice'],
              original_list_price: property['OriginalPrice'],
              square_footage: property['LotSquareFootage'],
              lot_features: property['RESILOTF'],
              tax_amount: property['RESITAXS'],
              tax_year: property['RESIYEAR'],
              disclaimer: property['PropertyDisclaimer'],
              picture_count: property['PictureCount'],
              publish_to_internet: property['PublishToInternet'],
              list_id: property['EnteredByMLSID'],
              listing_rid: property['ListingRid'])
    end

    def self.build_house(property)
      House.new(square_footage: property['SquareFootage'],
                total_bedrooms: property['Bedrooms'],
                total_bathrooms: property['Bathrooms'],
                appliances: property['RESIAPPL'],
                interior_features: property['RESIINTE'],
                basement_type: property['RESIBSFT'],
                garage_space: property['RESIGARR'],
                cooling: property['RESICOOL'],
                heating: property['RESIHEAT'],
                foundation: property['RESIFOUD'],
                year_built: property['RESIYEAR'])
    end

    def self.build_room(house, room_string, room_hash)
      house.rooms.new(category: room_string, width: room_hash["#{room_string}Wid"], length: room_hash["#{room_string}Len"])
    end
  end
end