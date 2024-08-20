import { useEffect,useState } from "react"
import { home } from "../lib/api"
import { Link } from "react-router-dom"
import { postAction } from "../lib/api"
import toast from "react-hot-toast"

export default function Home() {
    const [status, setStatus] = useState("loading")
    const [posts, setPosts] = useState(undefined)
    useEffect(() => {
        (async () => {
            const res = await home(1)
            if (res[0] === true) {
                setPosts(res[1])
                setStatus("show")
            }
        })()
    }, [])

    const handlePage = async (page) => {
        const postres = await home(page)
        setPosts(postres[1])
    }

    const handleLike = async (id) =>{
        const res = await postAction(id,"like")
        console.log(res)
        if(res[0] === true){
            // setPosts(p => {
            //     const rem = p.res.filter(fq => fq.id != id)
            //     const m = p.res.filter(fq => fq.id == id)
            //     m[0].likes += 1
                
            //     return { ...p, res: [...rem,...m] }
            // })
            toast.success("liked  post")
            return
        }
        if(Array.isArray(res[1])){
            res[1].error.forEach(error => {
                toast.error(error)
            });
            return 
        }
        toast.error(res[1].error)
    }
    const handleDislike = async (id) =>{
        const res = await postAction(id,"dislike")
        if(res[0] === true){
            // setPosts(p => {
            //     const rem = p.res.filter(fq => fq.id != id)
            //     const m = p.res.filter(fq => fq.id == id)
            //     m[0].dislikes += 1
            //     return { ...p, res: [...rem,...m] }
            // })
            toast.success("disliked  post")
            return
        }
        if(Array.isArray(res[1])){
            res[1].error.forEach(error => {
                toast.error(error)
            });
            return 
        }
        toast.error(res[1].error)
    }
    return (<div className="mt-[20px] w-[40%] mx-auto ">
        {status === "loading" && <span>Loading ....</span>}
        {status === "show" && <div>
            {posts.res.length == 0 ? <span>No Posts </span> :
                <div className="flex flex-col gap-[10px]">
                    {posts.res.map(p => <div className='p-4 border-[1px] border-black shadow-md shadow-gray-900/10 flex flex-col '>

                        <Link to={`/post/${p.id}`} className='font-semibold text-[24px]'>{p.caption}</Link>
                        <p className='mt-[10px] text-md'>{p.body}</p>
                        <div className="mt-[20px] carousel w-full">
                            {p.media.map((m, i) => <div id={`slide${i + 1}`} className="carousel-item relative w-full">
                                {m.type == "video/mp4" ? <video controls={true} src={m.url}></video> : <img src={m.url} className="w-full" />}
                                
                            </div>)}
                        </div>
                        <div className='mt-[20px] flex gap-[20px] justify-between'>
                            <div className='flex gap-[20px]'>
                                <button onClick={()=>handleLike(p.id)}>
                                    <div className='flex items-center gap-[5px]'>
                                        <svg className='w-[24px] h-[24px]' viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg"><g id="SVGRepo_bgCarrier" stroke-width="0"></g><g id="SVGRepo_tracerCarrier" stroke-linecap="round" stroke-linejoin="round"></g><g id="SVGRepo_iconCarrier"> <path d="M8 10V20M8 10L4 9.99998V20L8 20M8 10L13.1956 3.93847C13.6886 3.3633 14.4642 3.11604 15.1992 3.29977L15.2467 3.31166C16.5885 3.64711 17.1929 5.21057 16.4258 6.36135L14 9.99998H18.5604C19.8225 9.99998 20.7691 11.1546 20.5216 12.3922L19.3216 18.3922C19.1346 19.3271 18.3138 20 17.3604 20L8 20" stroke="#000000" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"></path> </g></svg>
                                        <span className=' text-md'>{p.likes}</span>
                                    </div>
                                </button>
                                <button onClick={()=>handleDislike(p.id)}>
                                    <div className='flex items-center gap-[5px]'>
                                        <svg className='w-[24px] h-[24px]' viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg"><g id="SVGRepo_bgCarrier" stroke-width="0"></g><g id="SVGRepo_tracerCarrier" stroke-linecap="round" stroke-linejoin="round"></g><g id="SVGRepo_iconCarrier"> <path d="M8 14V4M8 14L4 14V4.00002L8 4M8 14L13.1956 20.0615C13.6886 20.6367 14.4642 20.884 15.1992 20.7002L15.2467 20.6883C16.5885 20.3529 17.1929 18.7894 16.4258 17.6387L14 14H18.5604C19.8225 14 20.7691 12.8454 20.5216 11.6078L19.3216 5.60779C19.1346 4.67294 18.3138 4.00002 17.3604 4.00002L8 4" stroke="#000000" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"></path> </g></svg>
                                        <span className=' text-md'>{p.dislikes}</span>
                                    </div>
                                </button>
                            </div>
                        </div>


                    </div>)}
                    <div className="join flex justify-center mt-[20px] mb-[40px]">
                                {posts.current_page <= 1 ? null : <button onClick={() => handlePage(posts.current_page - 1)} className="join-item btn ">«</button>}
                                <button className="join-item btn">Page {posts.current_page} of {posts.total_page}</button>
                                {posts.current_page >= posts.total_page ? null : <button onClick={() => handlePage(posts.current_page + 1)} className="join-item btn ">»</button>}
                            </div>
                </div>
            }
        </div>}

    </div>)

}