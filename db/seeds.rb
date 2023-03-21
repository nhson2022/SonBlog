user = User.create(email: "son@example.com", password: "demo2023", password_confirmation: "demo2023")
30.times.each do |cindex|
  cate = Category.create(name: Faker::Food.ingredient, description: Faker::Quote.famous_last_words)
  puts "create new category: #{cate.name}"
  30.times.each do |aindex|
    article = Article.create(title: Faker::Quote.most_interesting_man_in_the_world, user: user, category: cate, content: Faker::Lorem.paragraphs(number: 10).join, active: true)
    puts "created article #{article.id} - #{article.title}"
  end
end