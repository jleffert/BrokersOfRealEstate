module BORE
  class SyncProperties
    ROOMS = ['MasterBedroom', '2ndBedroom', '3rdBedroom', '4thBedroom', 'FamilyRoom', 'FormalDiningRoom', 'GreatRoom', 
             'InformalDiningRoom', 'Kitchen', 'LaundryRoom', 'LivingRoom', 'Office', 'RecreationRoom']
    
    def self.initial_import
      rets = RubyRETS::RETS.new(ENV["RETS_USER_ID"], ENV["RETS_PASSWORD"], ENV["RETS_USER_AGENT"], 'http://rets172lax.raprets.com:6103')
      response = rets.login('/Midlands/MIDL/login.aspx')

      unless response == RubyRETS::Unauthorized
        properties = rets.search('Property', 'Residential','(City=|Lincoln),(MlsStatus=|A)', '/Midlands/MIDL/search.aspx')
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
            if room_hash["Room#{room}Area"] != "0"
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
      address = property['StreetNumberNumeric']
      address = "#{address} #{property['StreetDirPrefix']}" if property['StreetDirPrefix'].present?
      address = "#{address} #{property['StreetName']}"
      address = "#{address} #{property['StreetDirSuffix']}" if property['StreetDirSuffix'].present?
      address = "#{address} #{property['StreetSuffix']}"
      address = "#{address}  ##{property['UnitNumber']}" if property['Unit'].present?
      address
    end

    def self.build_lot(property)
      Lot.new(sub_type: property.fetch('PropertySubType'),
                              address: build_address(property),
                              zip: property['PostalCode'],
                              city: property['City'],
                              state: property['StateOrProvince'],
                              directions: property['Directions'],
                              list_price: property['ListPrice'],
                              original_list_price: property['OriginalListPrice'],
                              square_footage: property['LotSizeSquareFeet'],
                              lot_features: property['LotFeatures'],
                              water_source: property['WaterSource'],
                              electric_provider: property['Electric'],
                              gas_provider: property['Electric'],
                              tax_amount: property['TaxAnnualAmount'],
                              tax_year: property['TaxYear'],
                              disclaimer: property['Disclaimer'],
                              picture_count: property['PhotosCount'],
                              publish_to_internet: property['InternetEntireListingDisplayYN'],
                              list_id: property['ListingId'])
    end

    def self.build_house(property)
      House.new(square_footage: property['LivingArea'],
                                  appliances: property['Appliances'],
                                  interior_features: property['InteriorFeatures'],
                                  basement_type: property['Basement'],
                                  garage_space: property['GarageSpaces'],
                                  cooling: property['Cooling'],
                                  heating: property['Heating'],
                                  foundation: property['FoundationDetails'],
                                  year_built: property['YearBuilt'])
    end

    def self.build_room(house, room_string, room_hash)
      house.rooms.new(category: room_string, width: room_hash["Room#{room_string}Width"], length: room_hash["Room#{room_string}Length"])
    end
  end
end