class BaseRepository
  def find_by(klass, attrs)
    raise NoImplementeError
  end

  def save!(object)
    raise NotImplementedError
  end
end
