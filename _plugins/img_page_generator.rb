module Jekyll
    class ImagePageGenerator < Generator
      safe true
      priority :highest
  
      def generate(site)
        colname = site.config["images_collection"]
        site.collections[colname] = Collection.new(site, colname)
        images = site.static_files
        count = 1
        imagfolderpath = site.config["images_folder"]
        images.each do |imag|
          if imag.path.include? imagfolderpath
            myPage = ImagPage.new(site, site.source, imag, count, colname, imagfolderpath)
            site.collections[colname].docs << myPage
            count = count+1
          end
        end
      end
    end
  
    class ImagPage < Page
      def initialize(site1, base1, imag1, count1, colname1, imagfolderpath1)
        @site = site1
        @base = base1
        @dir  = File.join(colname1, imag1.basename)
        @name = 'index.html'
        @count = count1
  
        self.process(@name)
        self.read_yaml(File.join(base1, '_layouts'), 'images.html')
        self.data['imag'] = imag1
        self.data['number'] = count1
        self.data['collection'] = colname1
        self.data['title'] = site.config["images_ordinal_title"] + count1.to_s
        self.data['image'] = File.join(imagfolderpath1, imag1.name)

        # inicio config csc
        self.data['curso'] = imag1.basename[0,2]
        self.data['numDeLista'] = imag1.basename[2,2]
        len= imag1.basename.length
        keywordLen = ftl = site.config["images_filename_template"].length
        apellidoLen = len - keywordLen - 4
        self.data['apellido'] = imag1.basename[4,apellidoLen]

        self.data['tags'] = self.data['curso'] 

        #if imag1.name.start_with?(site.config["images_filename_template"])
        #  ftl = site.config["images_filename_template"].length
        #  ftl4 = ftl+4
        #  ftl6 = ftl+6
        #  self.data['date'] = imag1.basename[ftl,4]+"-"+imag1.basename[ftl4,2]+"-"+imag1.basename[ftl6,2]
        #end
      end
    end
  end
