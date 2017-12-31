module BORE
  class SyncRets
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

        properties.parsed['Residential']['Property'].each do |property|
          lot = build_lot(property)
          lot.save

          house = build_house(property)
          house.lot_id = lot.id
          house.save

          ROOMS.each do |room|
            room_hash = property.fetch('Structure', {})['Rooms'].select{|key, hash| key.include? room }
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
    def self.address_builder(address_hash)
      address = address_hash['StreetNumberNumeric']
      address = "#{address} #{address_hash['StreetDirPrefix']}" if address_hash['StreetDirPrefix'].present?
      address = "#{address} #{address_hash['StreetName']}"
      address = "#{address} #{address_hash['StreetDirSuffix']}" if address_hash['StreetDirSuffix'].present?
      address = "#{address} #{address_hash['StreetSuffix']}"
      address = "#{address}  ##{address_hash['UnitNumber']}" if address_hash['Unit'].present?
      address
    end

    def self.build_lot(property)
      Lot.new(sub_type: property.fetch('PropertySubType'),
                              address: address_builder(property.fetch('Location', {})['Address']),
                              zip: property.fetch('Location', {}).fetch('Address', {})['PostalCode'],
                              city: property.fetch('Location', {}).fetch('Address', {})['City'],
                              state: property.fetch('Location', {}).fetch('Address', {})['StateOrProvince'],
                              directions: property.fetch('Location', {}).fetch('GIS', {})['Directions'],
                              list_price: property.fetch('Listing', {}).fetch('Price', {})['ListPrice'],
                              original_list_price: property.fetch('Listing', {}).fetch('Price', {})['OriginalListPrice'],
                              square_footage: property.fetch('Characteristics', {})['LotSizeSquareFeet'],
                              lot_features: property.fetch('Characteristics',{})['LotFeatures'],
                              water_source: property.fetch('Utilities', {})['WaterSource'],
                              electric_provider: property.fetch('Utilities', {})['Electric'],
                              gas_provider: property.fetch('Utilities', {})['Electric'],
                              tax_amount: property.fetch('Tax', {})['TaxAnnualAmount'],
                              tax_year: property.fetch('Tax', {})['TaxYear'],
                              disclaimer: property.fetch('Listing', {})['Disclaimer'],
                              picture_count: property.fetch('Listing', {}).fetch('Media', {})['PhotosCount'],
                              publish_to_internet: property.fetch('Listing', {}).fetch('Marketing', {})['InternetEntireListingDisplayYN'],
                              list_id: property.fetch('Listing', {})['ListingId'])
    end

    def self.build_house(property)
      House.new(square_footage: property.fetch('Structure', {})['LivingArea'],
                                  appliances: property.fetch('Equipment', {})['Appliances'],
                                  interior_features: property.fetch('Structure', {})['InteriorFeatures'],
                                  basement_type: property.fetch('Structure', {})['Basement'],
                                  garage_space: property.fetch('Structure', {})['GarageSpaces'],
                                  cooling: property.fetch('Structure', {})['Cooling'],
                                  heating: property.fetch('Structure', {})['Heating'],
                                  foundation: property.fetch('Structure', {})['FoundationDetails'],
                                  year_built: property.fetch('Structure', {})['YearBuilt'])
    end

    def self.build_room(house, room_string, room_hash)
      house.rooms.new(category: room_string, width: room_hash["Room#{room_string}Width"], length: room_hash["Room#{room_string}Length"])
    end
  end
end