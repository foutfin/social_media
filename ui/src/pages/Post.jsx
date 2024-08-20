import { useEffect, useState } from 'react';
import { useParams } from 'react-router-dom';
import { getPostDetail } from '../lib/api';
import imgavatar from '../images/avatar.png'


export default function Post() {
    let { id } = useParams()
    const [status, setStatus] = useState("loading")
    const [postData, setPostData] = useState(undefined)

    useEffect(() => {
        (async () => {
            const res = await getPostDetail(id)
            if (res[0] === true) {
                setPostData(res[1].res)
                setStatus("show")

                return
            }
            if (res[1].status == 404) {
                setStatus("notfound")
            } else if (res[1].status == 403) {
                setStatus("notfriend")
            }
        })()
    }, [])
    console.log(status, postData?.media, postData)

    return (
        <div>
            {status === "loading" && <span>Loading ....</span>}
            {status === "notfound" && <h3>Post Not Found</h3>}
            {status === "notfriend" && <h3>Not in your friend list</h3>}
            {status === "show" && <div className='w-[40%] mx-auto'>
                <div className='mt-[50px]'>
                    <h2 className='font-bold text-xl'>{postData.caption}</h2>
                </div>
                <div className='mt-[20px]'>
                    <div className='flex items-center gap-[5px]'>
                        <img className='w-[48px] h-[48px] rounded-full ' src={postData.user.avatar ? postData.user.avatar: imgavatar} />
                        <div className='flex flex-col'>
                            <span>{postData.user.username}</span>
                            <span className='text-[14px] opacity-75'>{postData.created_at}</span>
                        </div>

                    </div>
                </div>
                <div className='mt-[20px]'>
                    <p >{postData.caption}</p>
                </div>
                <div className="mt-[20px] carousel w-full">
                    {postData.media.map((m, i) => <div id={`slide${i + 1}`} className="carousel-item relative w-full">
                        <img src={m.url} className="w-full" />
                        {/* <div className="absolute left-5 right-5 top-1/2 flex -translate-y-1/2 transform justify-between">
                            <a href="#slide4" className="btn btn-circle">❮</a>
                            <a href="#slide2" className="btn btn-circle">❯</a>
                        </div> */}
                    </div>)}

                </div>
                <div className='mt-[20px] flex gap-[20px]'>
                    <button>
                        <div className='flex items-center gap-[5px]'>
                            <svg className='w-[48px] h-[48px]' viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg"><g id="SVGRepo_bgCarrier" stroke-width="0"></g><g id="SVGRepo_tracerCarrier" stroke-linecap="round" stroke-linejoin="round"></g><g id="SVGRepo_iconCarrier"> <path d="M8 10V20M8 10L4 9.99998V20L8 20M8 10L13.1956 3.93847C13.6886 3.3633 14.4642 3.11604 15.1992 3.29977L15.2467 3.31166C16.5885 3.64711 17.1929 5.21057 16.4258 6.36135L14 9.99998H18.5604C19.8225 9.99998 20.7691 11.1546 20.5216 12.3922L19.3216 18.3922C19.1346 19.3271 18.3138 20 17.3604 20L8 20" stroke="#000000" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"></path> </g></svg>
                            <span className='font-bold'>{postData.likes}</span>
                        </div>
                    </button>
                    <button>
                        <div className='flex items-center gap-[5px]'>
                            <svg className='w-[48px] h-[48px]' viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg"><g id="SVGRepo_bgCarrier" stroke-width="0"></g><g id="SVGRepo_tracerCarrier" stroke-linecap="round" stroke-linejoin="round"></g><g id="SVGRepo_iconCarrier"> <path d="M8 14V4M8 14L4 14V4.00002L8 4M8 14L13.1956 20.0615C13.6886 20.6367 14.4642 20.884 15.1992 20.7002L15.2467 20.6883C16.5885 20.3529 17.1929 18.7894 16.4258 17.6387L14 14H18.5604C19.8225 14 20.7691 12.8454 20.5216 11.6078L19.3216 5.60779C19.1346 4.67294 18.3138 4.00002 17.3604 4.00002L8 4" stroke="#000000" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"></path> </g></svg>
                            <span className='font-bold'>{postData.dislikes}</span>
                        </div>
                    </button>
                </div>
            </div>}
        </div>
    )
}


