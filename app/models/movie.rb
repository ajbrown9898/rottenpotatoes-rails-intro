class Movie < ActiveRecord::Base
    @@list_ratings = ['G', 'PG', 'PG-13', 'R']
    def Movie.list_ratings
        return @@list_ratings
    end
end
