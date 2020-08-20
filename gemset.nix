{
  addressable = {
    dependencies = ["public_suffix"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1fvchp2rhp2rmigx7qglf69xvjqvzq7x0g49naliw29r2bz656sy";
      type = "gem";
    };
    version = "2.7.0";
  };
  colorator = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0f7wvpam948cglrciyqd798gdc6z3cfijciavd0dfixgaypmvy72";
      type = "gem";
    };
    version = "1.1.0";
  };
  concurrent-ruby = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1x07r23s7836cpp5z9yrlbpljcxpax14yw4fy4bnp6crhr6x24an";
      type = "gem";
    };
    version = "1.1.5";
  };
  em-websocket = {
    dependencies = ["eventmachine" "http_parser.rb"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1bsw8vjz0z267j40nhbmrvfz7dvacq4p0pagvyp17jif6mj6v7n3";
      type = "gem";
    };
    version = "0.5.1";
  };
  eventmachine = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0wh9aqb0skz80fhfn66lbpr4f86ya2z5rx6gm5xlfhd05bj1ch4r";
      type = "gem";
    };
    version = "1.2.7";
  };
  extras = {
    dependencies = ["forwardable-extended"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "08x9wmzmgq3a878396ffd2ic8z0chl3znilk386gcxvyyldd4nv2";
      type = "gem";
    };
    version = "0.3.0";
  };
  fastimage = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0ldc7zpjif4jr0w7qs4kr8dvfzi1gxgddfbkhsajqhnrd32ja5d7";
      type = "gem";
    };
    version = "2.1.3";
  };
  ffi = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "06mvxpjply8qh4j3fj9wh08kdzwkbnvsiysh0vrhlk5cwxzjmblh";
      type = "gem";
    };
    version = "1.11.1";
  };
  forwardable-extended = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "15zcqfxfvsnprwm8agia85x64vjzr2w0xn9vxfnxzgcv8s699v0v";
      type = "gem";
    };
    version = "2.6.0";
  };
  haml = {
    dependencies = ["temple" "tilt"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1q0a9fvqh8kn6wm97fcks6qzbjd400bv8bx748w8v87m7p4klhac";
      type = "gem";
    };
    version = "5.0.4";
  };
  "http_parser.rb" = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "15nidriy0v5yqfjsgsra51wmknxci2n2grliz78sf9pga3n0l7gi";
      type = "gem";
    };
    version = "0.6.0";
  };
  i18n = {
    dependencies = ["concurrent-ruby"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "038qvz7kd3cfxk8bvagqhakx68pfbnmghpdkx7573wbf0maqp9a3";
      type = "gem";
    };
    version = "0.9.5";
  };
  jekyll = {
    dependencies = ["addressable" "colorator" "em-websocket" "i18n" "jekyll-sass-converter" "jekyll-watch" "kramdown" "liquid" "mercenary" "pathutil" "rouge" "safe_yaml"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "01rnf0y7wx4rzh2ag74bg37vkxbg8m4nf450lypgh4khrarr3bhw";
      type = "gem";
    };
    version = "3.8.4";
  };
  jekyll-assets = {
    dependencies = ["concurrent-ruby" "extras" "fastimage" "jekyll" "pathutil" "rack" "sprockets"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0cx11mb03sq1mxf1v3m5vpi3rvmspkbp8bxg53ih9zfbg9fcjisx";
      type = "gem";
    };
    version = "2.4.0";
  };
  jekyll-sass-converter = {
    dependencies = ["sass"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "008ikh5fk0n6ri54mylcl8jn0mq8p2nfyfqif2q3pp0lwilkcxsk";
      type = "gem";
    };
    version = "1.5.2";
  };
  jekyll-seo-tag = {
    dependencies = ["jekyll"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "19yfr5i04gm50swbc6xxf4090z5z1v0kjfnvh695ydq1dkyx1csl";
      type = "gem";
    };
    version = "2.5.0";
  };
  jekyll-timeago = {
    dependencies = ["mini_i18n"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "19vhfvyljaaf4hasl8lkp0rfzaly6s8dpwr4c22d7lclg89v3llj";
      type = "gem";
    };
    version = "0.11.0";
  };
  jekyll-watch = {
    dependencies = ["listen"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1qd7hy1kl87fl7l0frw5qbn22x7ayfzlv9a5ca1m59g0ym1ysi5w";
      type = "gem";
    };
    version = "2.2.1";
  };
  kramdown = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1n1c4jmrh5ig8iv1rw81s4mw4xsp4v97hvf8zkigv4hn5h542qjq";
      type = "gem";
    };
    version = "1.17.0";
  };
  liquid = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0zhg5ha8zy8zw9qr3fl4wgk4r5940n4128xm2pn4shpbzdbsj5by";
      type = "gem";
    };
    version = "4.0.3";
  };
  listen = {
    dependencies = ["rb-fsevent" "rb-inotify"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1j3s7bprp2jfhgb959wd1h98978zg3207nl87yg8k5w7k08f7snb";
      type = "gem";
    };
    version = "3.2.0";
  };
  mercenary = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "10la0xw82dh5mqab8bl0dk21zld63cqxb1g16fk8cb39ylc4n21a";
      type = "gem";
    };
    version = "0.3.6";
  };
  mini_i18n = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1lfimv06h9a2snaihjvlykxwg85j81c9803s4gmp0vclqxpdjq7a";
      type = "gem";
    };
    version = "0.4.0";
  };
  pathutil = {
    dependencies = ["forwardable-extended"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "12fm93ljw9fbxmv2krki5k5wkvr7560qy8p4spvb9jiiaqv78fz4";
      type = "gem";
    };
    version = "0.16.2";
  };
  public_suffix = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0xnfv2j2bqgdpg2yq9i2rxby0w2sc9h5iyjkpaas2xknwrgmhdb0";
      type = "gem";
    };
    version = "4.0.1";
  };
  rack = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1riq0z408dwvqcqrpq05bp2w879l4sjxzb4cbrbx55kpi6h2g1cj";
      type = "gem";
    };
    version = "1.6.12";
  };
  rb-fsevent = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1lm1k7wpz69jx7jrc92w3ggczkjyjbfziq5mg62vjnxmzs383xx8";
      type = "gem";
    };
    version = "0.10.3";
  };
  rb-inotify = {
    dependencies = ["ffi"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1fs7hxm9g6ywv2yih83b879klhc4fs8i0p9166z795qmd77dk0a4";
      type = "gem";
    };
    version = "0.10.0";
  };
  rouge = {
    groups = ["default"];
    platforms = [];
    source = {
      fetchSubmodules = false;
      rev = "fb0ac75b5e28497baeff5df660f16e77591f8167";
      sha256 = "1agpnd0ijx4jdz004gps77cqlvq539s3cxqsx1jiyrv6ly0scslm";
      type = "git";
      url = "https://github.com/manastech/rouge.git";
    };
    version = "3.2.1";
  };
  safe_yaml = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0j7qv63p0vqcd838i2iy2f76c3dgwzkiz1d1xkg7n0pbnxj2vb56";
      type = "gem";
    };
    version = "1.0.5";
  };
  sass = {
    dependencies = ["sass-listen"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0p95lhs0jza5l7hqci1isflxakz83xkj97lkvxl919is0lwhv2w0";
      type = "gem";
    };
    version = "3.7.4";
  };
  sass-listen = {
    dependencies = ["rb-fsevent" "rb-inotify"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0xw3q46cmahkgyldid5hwyiwacp590zj2vmswlll68ryvmvcp7df";
      type = "gem";
    };
    version = "4.0.0";
  };
  sprockets = {
    dependencies = ["concurrent-ruby" "rack"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "182jw5a0fbqah5w9jancvfmjbk88h8bxdbwnl4d3q809rpxdg8ay";
      type = "gem";
    };
    version = "3.7.2";
  };
  temple = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "00nxf610nzi4n1i2lkby43nrnarvl89fcl6lg19406msr0k3ycmq";
      type = "gem";
    };
    version = "0.8.0";
  };
  tilt = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0020mrgdf11q23hm1ddd6fv691l51vi10af00f137ilcdb2ycfra";
      type = "gem";
    };
    version = "2.0.8";
  };
}