import type { NextPage } from "next";
import Head from "next/head";
import Image from "next/image";
import ExampleSketch from "../components/figures/ExampleSketch";

const Home: NextPage = () => {
  return (
    <div className="flex min-h-screen flex-col items-center justify-center py-2">
      <Head>
        <title>Louisiana Trail</title>
        <link rel="icon" href="/favicon.ico" />
      </Head>

      <ExampleSketch />
      <ExampleSketch />
    </div>
  );
};

export default Home;
