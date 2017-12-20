//Under GNU AGPL v3, see LICENCE

package beartek.comps;

import org.tamina.html.component.HTMLComponent;

@view('../template/comps/loader.html')
class Loader extends HTMLComponent {

  override public function attachedCallback() : Void {
    var particles = js.Browser.document.createElement('script');
    particles.setAttribute("type","text/javascript");
    particles.setAttribute("src", 'https://cdn.jsdelivr.net/particles.js/2.0.0/particles.min.js');
    particles.onload = function () : Void {
      untyped __js__('particlesJS("particles", {
        "particles": {
          "number": {
            "value": 185,
            "density": {
              "enable": true,
              "value_area": 1499.4041841268327
            }
          },
          "color": {
            "value": "#343A40"
          },
          "shape": {
            "type": "circle",
            "stroke": {
              "width": 0,
              "color": "#000000"
            },
            "polygon": {
              "nb_sides": 5
            },
            "image": {
              "src": "img/github.svg",
              "width": 100,
              "height": 100
            }
          },
          "opacity": {
            "value": 0.8,
            "random": true,
            "anim": {
              "enable": false,
              "speed": 1,
              "opacity_min": 0.3,
              "sync": false
            }
          },
          "size": {
            "value": 10,
            "random": true,
            "anim": {
              "enable": true,
              "speed": 25.087177943353133,
              "size_min": 0,
              "sync": true
            }
          },
          "line_linked": {
            "enable": true,
            "distance": 231.08602177160463,
            "color": "#5C8B93",
            "opacity": 0.4,
            "width": 1.5
          },
          "move": {
            "enable": true,
            "speed": 6,
            "direction": "none",
            "random": true,
            "straight": false,
            "out_mode": "out",
            "bounce": false,
            "attract": {
              "enable": false,
              "rotateX": 600,
              "rotateY": 1200
            }
          }
        },
        "interactivity": {
          "detect_on": "canvas",
          "events": {
            "onhover": {
              "enable": true,
              "mode": "bubble"
            },
            "onclick": {
              "enable": true,
              "mode": "repulse"
            },
            "resize": true
          },
          "modes": {
            "grab": {
              "distance": 400,
              "line_linked": {
                "opacity": 1
              }
            },
            "bubble": {
              "distance": 400,
              "size": 15,
              "duration": 2,
              "opacity": 8,
              "speed": 3
            },
            "repulse": {
              "distance": 200,
              "duration": 0.4
            },
            "push": {
              "particles_nb": 4
            },
            "remove": {
              "particles_nb": 2
            }
          }
        },
        "retina_detect": true
      })');
    }
    js.Browser.document.head.appendChild(particles);
  }

  override public function detachedCallback() : Void {
    untyped __js__('cancelRequestAnimFrame(pJSDom[0].pJS.fn.checkAnimFrame);
                    cancelRequestAnimFrame(pJSDom[0].pJS.fn.drawAnimFrame);
                    pJSDom[0].pJS.fn.particlesEmpty();
                    pJSDom[0].pJS.fn.canvasClear();');
  }

}
