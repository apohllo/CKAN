module CKAN
  class Group < Model
    self.site = API_BASE + "rest/group"

    attr_reader :id, :name
    lazy_reader :title, :description, :packages

    def initialize(id)
      @name = id
      @id = id
    end

    def self.find
      @all_groups ||= read_remote_json_data(self.site).map{|id| Group.get(id)}
    end

    alias api_packages packages
    protected :api_packages

    def packages
      @packages ||= self.api_packages.map{|p| Package.send(:get,p)}
    end

    protected
    def self.get(id)
      @group_map ||= {}
      unless @group_map[id]
        @group_map[id] = Group.new(id)
      end
      @group_map[id]
    end
  end
end
