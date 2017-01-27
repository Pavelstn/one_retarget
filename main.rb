def overlap_calculate_per_platform(input)
  input.each do |item| #Обнуляем счетчик пересечений временнвх отрезков
    item[:c]=0
  end
  input.each_with_index do |item_a, index_a|
    input.each_with_index do |item_b, index_b|
      if (index_a!= index_b) # не будем проверять пересечения сам с собой
        start_b= item_b[:start]
        stop_b= item_b[:start]+item_b[:delay]
        start_a= item_a[:start]
        stop_a= item_a[:start]+item_a[:delay]

        if (start_a<start_b&& stop_a>start_b|| start_a<stop_b&&stop_a>stop_b)
          item_a[:c]+=1
        end
      end
    end
  end

  return input.sort { |a, b| a[:c] <=> b[:c] }
end


def queue_calculate(input_array)
  # Основная идея- подсчет количества пересечений временных отрезков (очереди),
  # а затем удаление элемента с самым болшим количеством пересечений и повторным пересчетом, пока пересечений не отстанется.
  c=0

  input_array.each do |platform|
    begin
      conditional= true
      aaa= overlap_calculate_per_platform(platform[1])
      max_c= aaa.last
      if (max_c[:c]>0) #Если max_c[:c]>0 Значит где то есть пересечение и данный элемент имеет самое большое число пересечений  с другими, его и будем удалять
        aaa.pop()
        platform[1]= aaa.clone
      else
        conditional= false
      end
    end while conditional

    c+= platform[1].length
  end
  return c
end


def main
  input_array=Hash.new
  #Преобразуем входящий файл в хеш с ключем по названию(идентификатору) платформы
  File.readlines('input.txt').each do |line|
    arr= line.split("\s") # Почему \s, а не \t- некоторые текстовые редакторы автоматически конвертируют знак табуляции в несколько пробелов
    if !input_array.key?(arr[3].to_s)
      input_array[arr[3].to_s]= Array.new
    end
    input_array[arr[3].to_s].push({:node => arr[0], :start => arr[1].to_i, :delay => arr[2].to_i, :platform => arr[3], :c => 0})
  end


  result= queue_calculate(input_array)
  puts result
end


main()




