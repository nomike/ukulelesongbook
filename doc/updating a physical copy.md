# Updating your songbook
***Note:** If you have printed the printshop variant of the songbook, updates
are not possible, Only the refular variantsn can be updated.*

To print the update, lookup the songs version printed on the inner cover page of
your physical printout in the file `config/releases.json`. There you'll find the
print-strings for getting the guitar or ukulele edition up to date.

Open the PDF file in your favourite PDF viewer, go to the print dialog, select
the option to only print certain pages and copy/paste the print string from the
file `config/releases.json` into the field for specifing which pages to print.

***Note:** While I dont' own a mac to confirm this, it looks like there is no
such option in macos's preview app. If you know how to do this in macos,
please let me know. In Linux/Ubuntu/Gnome and Windows an option like that is
right there*

# Merging your songbook with the update
Merging the update takes little practice. I figured out this simple algorithm
that always works:

To prepare, remove the book rings from your songbook and put it on the table in
front of you (the todo-pile).
Punch holes in the update-pages and put them face up on a pile to the right
of your songbook (the update pile).
You will create two more piles on the left. One for the sorted out pages
(which you throw away at the end so I'll call it the burn pile) and one for the
updated songbook (the done pile).

So at the end you have these piles:

[A] [B] [C] [D]

A = Burn pile (face down)  
B = Done pile (face down)  
C = Todo pile (face up)  
D = Update pile (face up)  

The steps for the upgrade:

Compare the top page on piles C and D.

***Note:** The algorithm requires you to compare pages. This is done by
comparing the sort order (songtitle/artist). Of course there could be minor
differences in the page's contents, it's an update after all. But if the sort
order is the same, the pages are considered to be the same.*

If the pages on the todo and update pile have the same sort order, move the page
from the todo pile to the burn pile and the page from the update pile to the
done pile.

If the pages don't have the same sort order, move the page which comes first to
the done pile.

Repeat this until the todo and update stacks are empty.

Then you could put back the book-rings and throw away the pages from the burn
pile.

If you feel more comfortable reading this as pseudocode, here you are:

```
while len(todo) > 0 or len(update) > 0:
  if todo[0].sortorder == update[0].sortorder:
    move todo[0] -> burn
    move update[0] -> done
  if todo[0].sortorder < update[0].sortorder:
    move todo[0] -> done
  if update[0].sortorder < todo[0].sortorder:
    move update[0] -> done
```
