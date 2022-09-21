import React, { useEffect, useState } from "react";
import { render } from "react-dom";
import * as Tone from "tone";
import dynamic from "next/dynamic";

/* Dynamic import of p5.js. This is needed because p5.js uses the window object
for drawing window.innerWidth and window.innerHeight */
const Sketch = dynamic(() => import("react-p5").then((mod) => mod.default), {
  ssr: false,
});

function ExampleSketch() {
  const [synth, setSynth] = useState(null);

  /* UseEffect is a React Hook that runs a function when the component is mounted.
  it is needed here to initialize the synth and connect it to the speakers because
  it uses AudioBuffer, which is part of a web browser and can only be accessed once
  the component has mounted */
  useEffect(() => {
    setSynth(new Tone.Synth().toDestination());
  }, []);

  /* Plays a note for 1/60th of a second */
  const playSynth = () => {
    synth.triggerAttackRelease("C4", "60n");
  };

  /* p5.js setup function. Creates a canvas and an event listener for mouse
    clicks. When the canvas is clicked, the synth is played. */
  const setup = (p5, canvasParentRef) => {
    const cnv = p5.createCanvas(500, 500).parent(canvasParentRef);
    cnv.mousePressed(playSynth);

    p5.frameRate(30);
  };

  /* p5.js draw function */
  const draw = (p5) => {
    p5.fill(234, 31, 81);
    p5.noStroke();
    p5.rect(50, 50, 250, 250);
    p5.fill(255);
    p5.textStyle(p5.BOLD);
    p5.textSize(140);
    p5.text("p5*", 60, 250);
  };

  return <Sketch setup={setup} draw={draw} />;
}

export default ExampleSketch;
