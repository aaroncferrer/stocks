import { useState } from 'react';
import { FaGlobe } from 'react-icons/fa'
import { SiSmartthings } from 'react-icons/si'
import { BsFillPeopleFill } from 'react-icons/bs'
import AuthModal from '../../components/AuthModal';
import './landing.css'
import visionData from './visions.json';
import Nav from '../../components/Nav';

function Landing({setCurrentUser}) {
    const [showSignup, setShowSignup] = useState(false);
    const visions = visionData.visions;

    return(
        <main className="landing_container">
            <Nav setCurrentUser={setCurrentUser}/>

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
                    <h3>Navigating Opportunities , One Trade at a Time</h3>
                    <div className="vision">
                    {visions.map((vision) => (
                        <div className="vision_item" key={vision.id}>
                            {vision.logo === "FaGlobe" && <FaGlobe className='vision_logo' />}
                            {vision.logo === "SiSmartthings" && <SiSmartthings className='vision_logo' />}
                            {vision.logo === "BsFillPeopleFill" && <BsFillPeopleFill className='vision_logo' />}
                            <h5>{vision.title}</h5>
                            <p>{vision.description}</p>
                        </div>
                    ))}
                    </div>
                </div>
            </section>

        </main>
    )
}

export default Landing;