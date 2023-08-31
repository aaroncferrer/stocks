import { useState } from 'react';
import { FaGlobe } from 'react-icons/fa'
import { SiSmartthings } from 'react-icons/si'
import { BsFillPeopleFill } from 'react-icons/bs'
import AuthModal from '../../components/AuthModal';
import './landing.css'
import visionData from './visions.json';

function Landing() {
    const [showSignup, setShowSignup] = useState(false);
    const visions = visionData.visions;
    console.log(visions)

    return(
        <main className="landing_container">

            <AuthModal 
                showSignup={showSignup}
                setShowSignup={setShowSignup}
            />

            <section className="landing_text">
                <img src="./globe.png" alt="" className="globe_bg" />

                <h1>Fueling Your Financial Future</h1>
                <p>Empower your financial journey with <span className='text_highlight'>PesoTrade</span>, the ultimate stock trading app designed to bring simplicity, insight, and control to your investment endeavors. Dive into the world of stocks with confidence, backed by real-time data, powerful analysis tools, and a user-friendly interface.</p>
                <div className="div">
                    <button className='btns btn_primary' onClick={() => setShowSignup(true)}>
                        Create Account
                    </button>
                </div>
            </section>
            
            <section className="landing_about">
                <div className="vision_container">
                    <h1>Our Company Vision</h1>
                    <h2>Navigating Opportunities , One Trade at a Time</h2>
                    <div className="vision">
                        {visions.map((vision) => (
                            <>
                            {vision.logo === "FaGlobe" && <FaGlobe />}
                            {vision.logo === "SiSmartthings" && <SiSmartthings />}
                            {vision.logo === "BsFillPeopleFill" && <BsFillPeopleFill />}
                            <h4>{vision.title}</h4>
                            <p>{vision.description}</p>
                            </>
                        ))}
                    </div>
                </div>
            </section>

        </main>
    )
}

export default Landing;