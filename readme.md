# Roseheading

Commissioned work. As I developed this piece I was thinking about a few themes:

* Ken Knowlton's [call for mosaic art](http://www.kenknowlton.com/pages/07artcal.htm): "mosaic images... what better metaphor for civilizations frozen, fractured and abandoned? Let us make every possible sort of archive, for uncertain and remote archeologists, of what people were motivated by, and what they valued, and why the former destroyed the latter."
* The "cloud", which "can hold anything you want", rearranging itself constantly. Forged, faceted, and strengthened by multiple blows ([roseheaded](http://www.uvm.edu/histpres/203/nails.html)), both a relic and an indication of the time at which it was formed.
* Glitch aesthetics and the “unexplainable, unfathomable and otherworldly images and data structures" ([The Glitch Moment(um)](http://networkcultures.org/wpmu/portal/publications/network-notebooks/no-04-the-glitch-momentum/)) hidden in every glitch.

I initially developed the piece in Processing, but found processing.js too slow for the image manipulation. So I manually ported the entire code base to raw JavaScript + Canvas (the directories named `*Raw` are all written without Processing). This is my first time working with Canvas so I'm sure there are lots of mistakes. I built a miniature framework you can find in `shared/minps.js`.

The final compiled code resides in `Release` along with the "secret sauce" (source images). The release is built using the Google closure compiler, sitting adjacent to `build.sh` which automates the build process.

Thanks to Seb Lee-Delisle, Damian Stewart, and Marius Watz for advice and inspiration.