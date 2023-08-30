import Nav from '../../components/Nav';
import './landing.css'

function Landing() {
    return(
        <main className="landing_container">
            <Nav />
            <img src="./globe.png" alt="" className="globe_bg" />

            <div className="landing_text">
                <h1>Fueling Your Financial Future</h1>
                <p>Empower your financial journey with <span className='text_highlight'>PesoTrade</span>, the ultimate stock trading app designed to bring simplicity, insight, and control to your investment endeavors. Dive into the world of stocks with confidence, backed by real-time data, powerful analysis tools, and a user-friendly interface.</p>
                <div className="div">
                    <button className='btns btn_secondary'>Create Account</button>
                </div>
            </div>
        </main>
    )
}

export default Landing;