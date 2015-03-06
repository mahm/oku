crumb :root do
  link 'オークション一覧', root_path
end

crumb :category do |category|
  link category.name, [category, :auctions]
  parent :root
end

crumb :auction do |auction|
  link auction.title, [auction.category, auction]
  parent :category, auction.category
end

crumb :bids do |auction|
  link '入札 一覧'
  parent :auction, auction
end

crumb :bid do |bid|
  link '入札'
  parent :auction, bid.auction
end
