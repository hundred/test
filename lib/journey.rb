class Journey

  attr_reader :start_point, :end_point

  def initialize(transport:, start_point: nil, end_point: nil)
    @transport = transport
    @start_point = format_words(start_point)
    @end_point = format_words(end_point)
  end

  def complete!(end_point:)
    @end_point = format_words(end_point)
  end

  def fare_difference
    (basic_fare - final_tube_fare).round(2)
  end

  def basic_fare
    fare.public_send(@transport)
  end

  def final_tube_fare
    fare.calculate_final_fare(@start_point, @end_point)
  end

  private

  def format_words(word)
    word.downcase.gsub(/-|’|'/, "") if word
  end

  def fare
    @fare ||= Fare.new
  end
end
