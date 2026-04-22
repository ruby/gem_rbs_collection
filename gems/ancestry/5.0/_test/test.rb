require 'ancestry'

Ancestry.default_ancestry_format = :materialized_path2
Ancestry.default_ancestry_format
Ancestry.default_update_strategy = :sql
Ancestry.default_update_strategy
Ancestry.default_primary_key_format = '[-A-Fa-f0-9]{36}'
Ancestry.default_primary_key_format

class Directory < ActiveRecord::Base
  has_ancestry

  def rank
    1
  end
end

class Group < ActiveRecord::Base
  has_ancestry ancestry_column: :ancestry, orphan_strategy: :rootify, touch: true, counter_cache: true, primary_key_format: '[-A-Fa-f0-9]{36}', update_strategy: :sql, ancestry_format: :materialized_path2
end

class Category < ActiveRecord::Base
  has_ancestry orphan_strategy: :adopt, cache_depth: true, depth_cache_column: :ancestry_depth_cache, update_strategy: :ruby, ancestry_format: :materialized_path
end

class Tag < ActiveRecord::Base
  has_ancestry orphan_strategy: :none
end

class Item < ActiveRecord::Base
  has_ancestry cache_depth: 'item_depth'
end

class Node < ActiveRecord::Base
  has_ancestry cache_depth: :virtual
end

class MySerializer
  def initialize(parent, children:)
    @parent = parent
    @children = children
  end
end

Category.build_ancestry_from_parent_ids!
Category.check_ancestry_integrity!
Category.rebuild_depth_cache!
Category.rebuild_depth_cache_sql!

Group.rebuild_counter_cache!

Directory.arrange_nodes(Directory.all)
Directory.arrange_nodes(Directory.all, orphan_strategy: :rootify)
Directory.arrange_nodes(Directory.all, orphan_strategy: :destroy)
Directory.arrange_nodes(Directory.roots.to_a, orphan_strategy: :rootify)

node = Directory.find(1)
Directory.find(2).in_subtree_of?(node)

Directory.find(1).ancestors(from_depth: -6, to_depth: -4)
Directory.find(1).descendants(from_depth: 2, to_depth: 4)
Directory.find(1).path(from_depth: 3, to_depth: 4)
Directory.find(1).subtree(from_depth: 10, to_depth: 12)

Directory.arrange(order: 'id desc')
Directory.find_by!(name: 'Crunchy').subtree.arrange
Directory.find_by!(name: 'Crunchy').subtree.arrange(order: :name)

Directory.roots.to_a
Directory.ancestors_of(Directory.find(1).ancestors.first!).ancestors_of(1)
Directory.children_of(Directory.find(1).children.first!).children_of(1)
Directory.descendants_of(Directory.find(1).descendants.first!).descendants_of(1)
Directory.indirects_of(Directory.find(1).indirects.first!).indirects_of(1)
Directory.subtree_of(Directory.find(1).subtree.first!).subtree_of(1)
Directory.siblings_of(Directory.find(1).siblings.first!).siblings_of(1)
Directory.path_of(Directory.find(1).path.first!).path_of(1)

Directory.sort_by_ancestry(Directory.all.ordered_by_ancestry_and(id: :desc))
Directory.sort_by_ancestry(Directory.all.ordered_by_ancestry_and(id: :desc).offset(3).take(2))
Directory.sort_by_ancestry(Directory.all.ordered_by_ancestry_and(:rank))
Directory.sort_by_ancestry(Directory.all.ordered_by_ancestry_and(:rank)) { |a, b| a.rank <=> b.rank }

Group.arrange_serializable(order: :name)
Group.arrange_serializable { |parent, children| MySerializer.new(parent, children:) }
Group.arrange_serializable do |parent, children|
  {
    my_parent: parent,
    my_children: children
  }
end
Group.arrange_serializable(order: 'id desc') do |parent, children|
  out = {} #: Hash[String, untyped]
  out['parent'] = parent
  out['children'] = children if children.count > 1
  out
end
