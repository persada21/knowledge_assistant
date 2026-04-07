Rails.logger.info "Seeding documents..."

documents = [
  {
    title:         "Ruby on Rails History",
    original_text: <<~TEXT
      Ruby on Rails, often just called Rails, is an open-source web application framework written in Ruby. It was created by David Heinemeier Hansson, who extracted it from his work on Basecamp, a project management tool built by 37signals. Rails was first released as open source in July 2004 and quickly gained attention for its developer-friendly conventions.

      The framework follows two core principles: Convention over Configuration and Don't Repeat Yourself. Convention over Configuration means that Rails makes assumptions about what the developer wants to do, reducing the number of decisions needed. Don't Repeat Yourself means that every piece of knowledge should have a single, unambiguous representation in the system.

      Rails 1.0 was officially released in December 2005. It introduced the MVC architecture pattern to mainstream web development and popularized ideas like database migrations, RESTful routing, and scaffolding. These features made it possible for small teams to build sophisticated web applications in remarkably short timeframes.

      Rails 2.0 arrived in 2007 and brought RESTful conventions as the default approach. It also deprecated many older patterns and pushed developers toward cleaner API design. This version cemented Rails as a serious contender for building production web applications.

      The release of Rails 3.0 in 2010 was a major milestone. It merged with the Merb framework, bringing modularity and better performance. The new router, Active Model abstraction, and unobtrusive JavaScript support were key improvements. This version also introduced Bundler for dependency management.

      Rails 4.0 came out in 2013 with features like Strong Parameters, Turbolinks, and Russian Doll caching. These changes reflected a growing focus on security and performance. The framework dropped support for Ruby 1.8 and moved forward with a more modern Ruby ecosystem.

      Rails 5.0, released in 2016, introduced Action Cable for WebSocket support, making real-time features a first-class citizen. It also added the API-only application mode, acknowledging that many developers were using Rails purely as a backend for JavaScript frontends or mobile apps.

      Rails 6.0 launched in 2019 with Action Mailbox, Action Text, and multiple database support. It also introduced parallel testing out of the box, significantly speeding up large test suites. Webpack became the default JavaScript bundler through Webpacker.

      Rails 7.0 arrived in late 2021 and made a bold move by replacing Webpack with import maps and embracing Hotwire (Turbo and Stimulus) as the default front-end approach. It also dropped Node.js as a dependency for new applications and introduced encrypted database fields.

      Throughout its history, Rails has powered major platforms including GitHub, Shopify, Airbnb, Twitch, and Hulu. Its influence extends beyond Ruby, inspiring frameworks like Django, Laravel, Phoenix, and many others. The Rails community remains active with regular conferences like RailsConf and an extensive ecosystem of gems.
    TEXT
  },
  {
    title:         "Computer History",
    original_text: <<~TEXT
      The history of computing stretches back centuries, beginning with simple mechanical devices designed to assist with calculation. The abacus, used in ancient Mesopotamia and China, is often considered the earliest computing tool. It allowed users to perform arithmetic operations by sliding beads along rods.

      In 1642, Blaise Pascal built the Pascaline, a mechanical calculator that could perform addition and subtraction. A few decades later, Gottfried Wilhelm Leibniz improved on Pascal's design with the Stepped Reckoner, which could also multiply and divide. These machines were limited but demonstrated that mechanical devices could handle mathematical operations.

      Charles Babbage is widely regarded as the father of computing. In the 1830s, he designed the Analytical Engine, a general-purpose mechanical computer that included concepts like an arithmetic logic unit, control flow, and memory. Ada Lovelace, who worked with Babbage, wrote what is considered the first computer program, making her the world's first programmer.

      The early twentieth century brought electromechanical machines. In 1936, Alan Turing published his paper on computable numbers, introducing the concept of the Turing machine, a theoretical model that defines the limits of what can be computed. This paper laid the mathematical foundation for all modern computers.

      During World War II, computing advanced rapidly due to military needs. The Colossus machines, built in Britain, were used to break German encrypted messages. In the United States, the ENIAC, completed in 1945, was the first general-purpose electronic computer. It weighed 30 tons and occupied an entire room but could perform thousands of calculations per second.

      The invention of the transistor at Bell Labs in 1947 transformed computing. Transistors replaced vacuum tubes, making computers smaller, faster, and more reliable. This led to the second generation of computers in the late 1950s and early 1960s, which were used primarily by governments and large corporations.

      The integrated circuit, invented independently by Jack Kilby and Robert Noyce in 1958, placed multiple transistors on a single chip. This breakthrough led to the minicomputer era of the 1960s and eventually to the microprocessor. Intel released the first commercial microprocessor, the Intel 4004, in 1971.

      Personal computing exploded in the late 1970s and 1980s. The Apple II, released in 1977, was one of the first successful mass-produced personal computers. IBM entered the market in 1981 with the IBM PC, which became the industry standard. Microsoft provided the operating system, MS-DOS, and later Windows, which dominated the desktop market for decades.

      The 1990s brought the World Wide Web, invented by Tim Berners-Lee at CERN in 1989. The web transformed computers from isolated machines into connected devices, enabling email, online commerce, and information sharing on a global scale. Browsers like Netscape Navigator and Internet Explorer made the web accessible to everyday users.

      The twenty-first century has been defined by mobile computing, cloud infrastructure, and the rise of artificial intelligence. Smartphones, led by the iPhone in 2007, put powerful computers in everyone's pockets. Cloud platforms like AWS, Google Cloud, and Azure shifted computing from local machines to massive data centers. Today, computing continues to evolve with quantum computing, edge computing, and machine learning pushing the boundaries of what is possible.
    TEXT
  },
  {
    title:         "AI History",
    original_text: <<~TEXT
      Artificial intelligence as a formal field began in the summer of 1956 at a workshop held at Dartmouth College. John McCarthy, who coined the term "artificial intelligence," organized the event along with Marvin Minsky, Nathaniel Rochester, and Claude Shannon. The attendees believed that every aspect of learning could be described precisely enough for a machine to simulate it.

      The early years of AI research, from the late 1950s through the 1960s, were marked by optimism and ambitious goals. Researchers developed programs that could play checkers, prove mathematical theorems, and solve algebra problems. The General Problem Solver, created by Allen Newell and Herbert Simon, was an early attempt at building a universal reasoning program.

      The first AI winter hit in the 1970s. Progress had not met the high expectations set by early researchers, and funding began to dry up. A 1973 report by James Lighthill in the UK criticized AI for failing to deliver on its promises. Government funding in both the US and UK was significantly reduced, slowing research for nearly a decade.

      Expert systems brought a revival in the 1980s. These programs used hand-coded rules from human experts to make decisions in specific domains like medical diagnosis and financial planning. MYCIN, developed at Stanford, could diagnose bacterial infections. Companies invested heavily in AI, and the market for expert systems grew rapidly.

      The second AI winter arrived in the late 1980s and early 1990s. Expert systems proved expensive to maintain and brittle outside their narrow domains. The Lisp machine market collapsed, and corporate interest faded. AI research continued in universities but at a much lower profile.

      A turning point came in 1997 when IBM's Deep Blue defeated world chess champion Garry Kasparov. While Deep Blue relied on brute-force search rather than general intelligence, the event captured public imagination and demonstrated that machines could outperform humans in complex strategic tasks.

      Machine learning gradually replaced rule-based approaches during the 2000s. Instead of programming explicit rules, researchers trained algorithms on data and let them learn patterns. Support vector machines, random forests, and other statistical methods became widely used in spam filtering, recommendation systems, and image recognition.

      The deep learning revolution began around 2012 when a neural network called AlexNet won the ImageNet image recognition competition by a large margin. Deep learning uses multi-layered neural networks that can learn hierarchical representations from raw data. The availability of large datasets and powerful GPUs made training these networks practical.

      Natural language processing saw dramatic progress with the introduction of the Transformer architecture in 2017. Google's paper "Attention Is All You Need" described a model that processes text in parallel rather than sequentially, enabling much faster training. This architecture became the foundation for GPT, BERT, and other large language models.

      Today, AI is embedded in daily life through virtual assistants, autonomous vehicles, medical imaging, content recommendation, and language translation. Large language models like GPT can generate coherent text, write code, and answer complex questions. The field continues to grapple with challenges including bias, safety, energy consumption, and the societal impact of increasingly capable systems.
    TEXT
  }
]

documents.each do |attrs|
  doc = Document.find_or_initialize_by(title: attrs[:title])
  doc.original_text = attrs[:original_text]

  if doc.new_record?
    doc.save!
    DocumentProcessingJob.perform_now(doc.id)
    doc.reload
    Rails.logger.info "  Created and processed: #{doc.title} (#{doc.chunk_count} chunks)"
  else
    Rails.logger.info "  Already exists: #{doc.title}"
  end
end

Rails.logger.info "Done! #{Document.count} documents total."
