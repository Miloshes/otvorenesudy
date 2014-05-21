module OpenCourts
  module VERSION
    MAJOR = 1
    MINOR = 0
    PATCH = 15

    PRE = 'beta'

    STRING = [MAJOR, MINOR, PATCH, PRE].compact.join '.'
  end
end
